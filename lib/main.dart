import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'question_model.dart';
import 'widgets.dart';
import 'startScreen.dart';
import 'esensehandling.dart';

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

  //------------------------------------------esense logic
  StreamSubscription? subscription;
  void _listenToSensorEvents() async {
    if (geh.isConnected()) {
      subscription = geh.manager!.sensorEvents.listen((event) {
        //if the person shakes his head, a new question is loaded.
        if (event.accel![2] <= -4000) {
          handleNewQuestion();
        }
      });
    }
  }

  void _pauseListenToSensorEvents() async {
    subscription?.cancel();
  }

  //-----------------------------------------end of esense logic

  //fetch  a new question, set currentQuetion and shuffledOptionList variable - setState
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
    //start listening to esensor data as well
    _listenToSensorEvents();
  }

  @override
  void dispose() {
    _pauseListenToSensorEvents();
    super.dispose();
  }

  getNewQuestion() {
    setState(() {
      handleNewQuestion();
      colors = [notSelected, notSelected, notSelected, notSelected];
    });
  }

  //color correct answer-card green.
  //if tapped answer card was not the correct one, color it red. If it was correct, increase score
  //get new question
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
              //Option cards
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
