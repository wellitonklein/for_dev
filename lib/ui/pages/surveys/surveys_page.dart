import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../widgets/widgets.dart';
import 'survey_viewmodel.dart';
import 'surveys_presenter_interface.dart';
import 'widgets/widgets.dart';

class SurveysPage extends StatelessWidget
    with LoadingMixin, NavigationMixin, SessionMixin {
  final ISurveysPresenter presenter;

  const SurveysPage({@required this.presenter});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(builder: (context) {
        handleLoading(context: context, stream: presenter.isLoadingStream);
        handleNavigation(stream: presenter.navigateToStream);
        handleSessionExpired(stream: presenter.isSessionExpiredStream);
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
              return Provider(
                create: (_) => presenter,
                child: SurveyItemsWidget(viewModels: snapshot.data),
              );
            }

            return SizedBox(height: 0);
          },
        );
      }),
    );
  }
}
