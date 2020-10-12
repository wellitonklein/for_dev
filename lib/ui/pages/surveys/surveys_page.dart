import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';
import 'survey_viewmodel.dart';
import 'surveys_presenter_interface.dart';
import 'widgets/widgets.dart';

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
              return SurveyItemsWidget(viewModels: snapshot.data);
            }

            return SizedBox(height: 0);
          },
        );
      }),
    );
  }
}
