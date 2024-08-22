import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class HeartLevelSelectionView extends StatefulWidget {

  final void Function(int) onValueChanged;

  const HeartLevelSelectionView({super.key, required this.onValueChanged});


  @override
  State<HeartLevelSelectionView> createState() => _HeartLevelSelectionViewState();
}

class _HeartLevelSelectionViewState extends State<HeartLevelSelectionView> {
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Mild".tr().text.color(AppColor.primaryColor).lg.fontFamily(AppFonts.appFont).make().expand(),
              Radio(
                value: 0,
                groupValue: _groupValue,
                onChanged: (int? newValue) {
                  setState(()  {
                    _groupValue = newValue ?? 0;
                    widget.onValueChanged(_groupValue);
                  });
                } ,
                activeColor: AppColor.primaryColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Medium".tr().text.color(AppColor.primaryColor).lg.fontFamily(AppFonts.appFont).make().expand(),
              Radio(
                value: 1,
                groupValue: _groupValue,
                onChanged: (int? newValue) {
                  setState(()  {
                    _groupValue = newValue ?? 0;
                    widget.onValueChanged(_groupValue);
                  });
                } ,
                activeColor: AppColor.primaryColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Hot".tr().text.color(AppColor.primaryColor).lg.fontFamily(AppFonts.appFont).make().expand(),
              Radio(
                value: 2,
                groupValue: _groupValue,
                onChanged: (int? newValue) {
                  setState(()  {
                    _groupValue = newValue ?? 0;
                    widget.onValueChanged(_groupValue);
                  });
                } ,
                activeColor: AppColor.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

}
