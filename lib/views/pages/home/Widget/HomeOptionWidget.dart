import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class HomeOptionWidget extends StatelessWidget {
  const HomeOptionWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  final String? title;
  final String? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 200,
        padding: const EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage(
                'assets/images/home_option_bg.png',
              ),
              fit: BoxFit.contain),
          borderRadius: BorderRadius.circular(200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (null != icon && (icon?.isNotEmpty ?? false))
              Image.network(
                icon!, fit: BoxFit.fill,
                height: 50,
                // width: 50,
              ),
            (title ?? "")
                .text
                .color(AppColor.primary)
                .fontFamily(AppFonts.appFont)
                .align(TextAlign.center)
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make()
          ],
        ).pSymmetric(h: 10),
      ),
    );
  }
}
