import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../survey_viewmodel.dart';
import 'survey_item_widget.dart';

class SurveyItemsWidget extends StatelessWidget {
  final List<SurveyViewModel> viewModels;

  const SurveyItemsWidget({@required this.viewModels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        items: viewModels
            .map((viewModel) => SurveyItemWidget(viewModel: viewModel))
            .toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
      ),
    );
  }
}
