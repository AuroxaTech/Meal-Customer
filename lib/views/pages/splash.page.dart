import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/view_models/splash.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));*/
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return BasePage(
      body: ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return VStack(
            [
              //
              Image.asset(AppImages.appLogo)
                  .wh(context.percentWidth * 90, context.percentWidth * 90)
                  .box
                  .clip(Clip.antiAlias)
                  .roundedSM
                  .makeCentered()
                  .py12(),
              //linear progress indicator
              LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.theme.primaryColor,
                ),
              ).w(context.percentWidth * 80),
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.center,
          ).centered();
        },
      ),
    );
  }
}
