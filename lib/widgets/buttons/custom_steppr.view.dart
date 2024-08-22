import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({
    Key? key,
    this.defaultValue,
    this.max,
    required this.onChange,
  }) : super(key: key);

  final int? defaultValue;
  final int? max;
  final Function(int) onChange;
  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int qty = 0;

  @override
  void initState() {
    super.initState();

    //
    setState(() {
      qty = widget.defaultValue ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        if(qty != 0)
        Image.asset(AppImages.minusSign,height: 40,).p4().onInkTap(() {
          if (qty > 0) {
            setState(() {
              qty -= 1;
            });
            //
            widget.onChange(qty);
          }
        }),
        //
        if(qty != 0)
        "$qty".text.fontFamily(AppFonts.appFont).bold
            .color(AppColor.primaryColor).make().p4().px8(),
        //
        Image.asset(AppImages.plusSign,height: 40,).p4().onInkTap(() {
          if (widget.max != null && widget.max! > qty) {
            setState(() {
              qty += 1;
            });
            //
            widget.onChange(qty);
          }
        }),
      ],
    ).box.make();
  }
}
