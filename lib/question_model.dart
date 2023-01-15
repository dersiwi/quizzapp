import 'package:http/http.dart' as http;
import 'dart:convert';

class Question {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // see : https://the-trivia-api.com/docs/#getQuestions
    String corrAnswer = json['correctAnswer'];
    var tagsJson = json['incorrectAnswers'];
    List<String> incQuesetions = List.from(tagsJson);
    List<String> allPossibleAnswers = List.from(incQuesetions);
    allPossibleAnswers.add(corrAnswer);

    return Question(
      correctAnswer: corrAnswer,
      question: json['question'] as String,
      incorrectAnswers: incQuesetions,
    );
  }
}

//create a list of all possible answers (correct + incorrect) and shuffle
List<String> createRandomOptionList(Question q) {
  List<String> randomOptionList = List.from(q.incorrectAnswers);
  randomOptionList.add(q.correctAnswer);
  randomOptionList.shuffle();
  return randomOptionList;
}

//activeQuestion and activeOptionList hold the question and option being displayed
Question activeQuestion = Question(
    question:
        "If you see this, click on one of the answer option to continue...",
    correctAnswer: "loading...",
    incorrectAnswers: List.from({"loading...", "loading...", "loading..."}));
List<String> activeOptionList = createRandomOptionList(activeQuestion);

Question errorQuestion = Question(
    question:
        "Sorry! We're having problems fetching your questions from the API we're using. ",
    correctAnswer: "Please make sure ou are connected to the internet",
    incorrectAnswers: List.from({
      "Check if the API is still online at : https://the-trivia-api.com/",
      "Sorry!",
      "Sorry!"
    }));

String API_GET_REQUEST =
    'https://the-trivia-api.com/api/questions?limit=20&categories=science,history';

/*
  Perform get-request to url stored in API_GET_REQUEST.
  Parse response and return parsed response in question-object.
  in case of error or failure , return errorQuestion.
*/
Future<Question> fetchQuestion() async {
  try {
    final response = await http.get(Uri.parse(API_GET_REQUEST));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      activeQuestion = Question.fromJson(jsonDecode(response.body)[0]);
      activeOptionList = createRandomOptionList(activeQuestion);
      return activeQuestion;
    }
    return errorQuestion;
  } on Exception catch (e) {
    return errorQuestion;
  }
}
