import 'package:flutter/material.dart';
import 'main.dart';
import 'apicalls.dart';
import 'widgets.dart';
import 'constants.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Option(
                    optionContent: "You shook your head x times",
                    color: notSelected,
                    heightModificator: 0.5),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < availableCategories.length; i++)
                  CategoryOptionCard(
                      index: i, questionCategory: availableCategories[i]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryOptionCard extends StatelessWidget {
  const CategoryOptionCard(
      {super.key, required this.index, required this.questionCategory});
  final int index;
  final QuestionCategory questionCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Option(
          optionContent: questionCategory.categoryName,
          color: Colors.redAccent,
          heightModificator: optionCardHeight),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              API_CALL: createAPIcall(List.from({index})),
            ),
          ),
        );
      },
    );
  }
}
