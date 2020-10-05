import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import 'widgets/survey_item_widget.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
