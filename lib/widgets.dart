import 'package:flutter/material.dart';
import 'constants.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key, required this.question});
  final String question;
  @override
  Widget build(BuildContext context) {
    return Text(
      question,
      style: TextStyle(
        fontSize: questionFontSize,
        fontWeight: FontWeight.bold,
        color: questionFontColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class Option extends StatelessWidget {
  const Option(
      {super.key,
      required this.optionContent,
      required this.color,
      required this.heightModificator});

  final String optionContent;
  final Color color;
  final double heightModificator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * optionCardHeight,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: color,
        elevation: 5, //shadow
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              optionContent,
              style:
                  TextStyle(color: optionFontColor, fontSize: optionFontSize),
            ),
          ),
        ),
      ),
    );
  }
}
