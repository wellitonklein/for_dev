import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../widgets/widgets.dart';
import 'survey_viewmodel.dart';
import 'surveys_presenter_interface.dart';
import 'widgets/widgets.dart';

class SurveysPage extends StatefulWidget {
  final ISurveysPresenter presenter;

  const SurveysPage({@required this.presenter});

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingMixin, NavigationMixin, SessionMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(builder: (context) {
        handleLoading(
            context: context, stream: widget.presenter.isLoadingStream);
        handleNavigation(stream: widget.presenter.navigateToStream);
        handleSessionExpired(stream: widget.presenter.isSessionExpiredStream);
        widget.presenter.loadData();

        return StreamBuilder<List<SurveyViewModel>>(
          stream: widget.presenter.surveysStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ReloadScreenWidget(
                error: snapshot.error,
                reload: widget.presenter.loadData,
              );
            }

            if (snapshot.hasData) {
              return Provider(
                create: (_) => widget.presenter,
                child: SurveyItemsWidget(viewModels: snapshot.data),
              );
            }

            return SizedBox(height: 0);
          },
        );
      }),
    );
  }

  @override
  void didPopNext() {
    widget.presenter.loadData();
    super.didPop();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }
}
