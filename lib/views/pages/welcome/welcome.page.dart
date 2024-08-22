import 'package:flutter/material.dart';
import 'package:mealknight/constants/home_screen.config.dart';
import 'package:mealknight/view_models/welcome.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with AutomaticKeepAliveClientMixin<WelcomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      body: ViewModelBuilder<WelcomeViewModel>.reactive(
        viewModelBuilder: () => WelcomeViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        disposeViewModel: false,
        builder: (context, vm, child) {
          return SmartRefresher(
            controller: vm.refreshController,
            onRefresh: () => vm.initialise(initial: false),
            enablePullDown: true,
            enablePullUp: false,
            child: HomeScreenConfig.homeScreen(vm, vm.pageKey),
          );
        },
      ),
    );
  }
}
