import 'package:flutter/material.dart';

import '../viewmodels/viewmodels.dart';
import 'widgets.dart';

class SurveyResultWidget extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final Future<void> Function({@required String answer}) onSave;

  const SurveyResultWidget({
    @required this.viewModel,
    @required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeaderWidget(question: viewModel.question);
        }
        final answer = viewModel.answers[index - 1];
        return GestureDetector(
          onTap: () =>
              answer.isCurrentAnswer ? null : onSave(answer: answer.answer),
          child: SurveyAnswerWidget(viewModel: answer),
        );
      },
    );
  }
}
