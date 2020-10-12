import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';
import 'survey_viewmodel.dart';
import 'surveys_presenter_interface.dart';
import 'widgets/survey_item_widget.dart';

class SurveysPage extends StatelessWidget {
  final ISurveysPresenter presenter;

  const SurveysPage({@required this.presenter});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.loadData();

        return StreamBuilder<List<SurveyViewModel>>(
          stream: presenter.surveysStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ReloadScreenWidget(
                error: snapshot.error,
                reload: presenter.loadData,
              );
            }

            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CarouselSlider(
                  items: snapshot.data
                      .map(
                        (viewModel) => SurveyItemWidget(viewModel: viewModel),
                      )
                      .toList(),
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    aspectRatio: 1,
                  ),
                ),
              );
            }

            return SizedBox(height: 0);
          },
        );
      }),
    );
  }
}
