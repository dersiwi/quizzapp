import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'question_model.dart';
import 'widgets.dart';
import 'startScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.API_CALL});

  final String API_CALL;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int score = 0;
  late Question currentQuestion;
  late List<String> shuffledOptionList;
  List<Color> colors = [notSelected, notSelected, notSelected, notSelected];

  handleNewQuestion() {
    try {
      fetchQuestion();
      currentQuestion = activeQuestion;
      shuffledOptionList = activeOptionList;
    } on Exception catch (e) {
      print("EXCEPTION : COULD NOT LOAD DATA FROM API.");
      print(e.toString());
      currentQuestion = Question(
        question:
            "We're having problems loading your question. Please try again later.",
        incorrectAnswers: List.from({"Unable to load option"}),
        correctAnswer: "Unable to load correct answer",
      );
      shuffledOptionList = createRandomOptionList(currentQuestion);
    }
  }

  @override
  void initState() {
    API_GET_REQUEST = widget.API_CALL;
    handleNewQuestion();
    super.initState();
  }

  getNewQuestion() {
    setState(() {
      handleNewQuestion();
      colors = [notSelected, notSelected, notSelected, notSelected];
    });
  }

  processClick(clickedIndex) async {
    setState(() {
      if (shuffledOptionList[clickedIndex] == currentQuestion.correctAnswer) {
        //answer was correct
        score++;
        colors[clickedIndex] = correct;
      } else {
        //answer was not correct
        colors[clickedIndex] = incorrect;
        //get the correct index and color it green

        for (int i = 0; i < shuffledOptionList.length; i++) {
          if (shuffledOptionList[i] == currentQuestion.correctAnswer) {
            colors[i] = correct;
          }
        }
      }
    });
    await Future.delayed(Duration(seconds: 1));
    getNewQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Correct questions : ${score}"),
        backgroundColor: barColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              QuestionWidget(question: currentQuestion.question),
              Spacer(
                flex: 2,
              ),
              for (int i = 0; i < shuffledOptionList.length; i++)
                GestureDetector(
                  child: Option(
                      optionContent: shuffledOptionList[i],
                      color: colors[i],
                      heightModificator: optionCardHeight),
                  onTap: () {
                    processClick(i);
                  },
                ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
