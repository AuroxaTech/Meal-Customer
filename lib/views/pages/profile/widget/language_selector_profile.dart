import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:mealknight/constants/app_languages.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/utils/ui_spacer.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/widgets/custom_grid_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AppLanguageSelectorProfile extends StatelessWidget {
  const AppLanguageSelectorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: VStack(
        [
          //
          "Select your preferred language"
              .tr()
              .text
              .xl
              .semiBold
              .make()
              .py20()
              .px12(),
          UiSpacer.divider(),

          //
          CustomGridView(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: EdgeInsets.all(12),
            dataSet: AppLanguages.profileLangCodes,
            itemBuilder: (ctx, index) {
              return VStack(
                [
                  //
                  Flag.fromString(
                    AppLanguages.profileLangFlags[index],
                    height: 40,
                    width: 40,
                  ),
                  UiSpacer.verticalSpace(space: 5),
                  //
                  AppLanguages.profileLangNames[index].text.lg.make(),
                ],
                crossAlignment: CrossAxisAlignment.center,
                alignment: MainAxisAlignment.center,
              ).box.roundedSM.color(context.canvasColor).make().onTap(() {
                _onSelected(context, AppLanguages.profileLangCodes[index]);
              });
            },
          ).expand(),
        ],
      ),
    ).hThreeForth(context);
  }

  void _onSelected(BuildContext context, String code) async {
    await AuthServices.setLocale(code);
    //
    await LocalizeAndTranslate.setLanguageCode(code);

    await Utils.setJiffyLocale();
    //
    Navigator.of(context).pop(true);
  }
}
