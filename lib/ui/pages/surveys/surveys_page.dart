import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import 'surveys_presenter_interface.dart';
import 'widgets/survey_item_widget.dart';

class SurveysPage extends StatelessWidget {
  final ISurveysPresenter presenter;

  const SurveysPage({@required this.presenter});
  @override
  Widget build(BuildContext context) {
    presenter.loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CarouselSlider(
          items: [
            SurveyItemWidget(),
            SurveyItemWidget(),
            SurveyItemWidget(),
          ],
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
        ),
      ),
    );
  }
}
