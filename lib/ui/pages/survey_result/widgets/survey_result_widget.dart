import 'package:flutter/material.dart';

import '../viewmodels/viewmodels.dart';
import 'widgets.dart';

class SurveyResultWidget extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResultWidget({@required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeaderWidget(question: viewModel.question);
        }
        return SurveyAnswerWidget(viewModel: viewModel.answers[index - 1]);
      },
    );
  }
}
