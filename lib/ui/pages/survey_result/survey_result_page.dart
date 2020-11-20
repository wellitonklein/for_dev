import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import '../../widgets/widgets.dart';
import 'survey_result_presenter_interface.dart';
import 'viewmodels/viewmodels.dart';
import 'widgets/widgets.dart';

class SurveyResultPage extends StatelessWidget with LoadingMixin, SessionMixin {
  final ISurveyResultPresenter presenter;

  const SurveyResultPage({@required this.presenter});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Result'),
      ),
      body: Builder(builder: (context) {
        handleLoading(context: context, stream: presenter.isLoadingStream);
        handleSessionExpired(stream: presenter.isSessionExpiredStream);
        presenter.loadData();

        return StreamBuilder<SurveyResultViewModel>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreenWidget(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return SurveyResultWidget(viewModel: snapshot.data);
              }

              return SizedBox(height: 0);
            });
      }),
    );
  }
}
