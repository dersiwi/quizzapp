import 'package:flutter/material.dart';
import 'main.dart';
import 'apicalls.dart';
import 'widgets.dart';
import 'constants.dart';
import 'bluetooth_related.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WearableWidget(),
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
          color: backgroundColor,
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
