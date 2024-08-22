import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_font.dart';

class ProfileOptionWidget extends StatelessWidget {
  const ProfileOptionWidget(
      {super.key,
        required this.title,
        required this.icon,
        required this.onTap});

  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration:icon != "" && title != ""? BoxDecoration(
          image: const DecorationImage(
              image: AssetImage(
                'assets/images/home_option_bg1.png',
              ),
              fit: BoxFit.contain),
          borderRadius: BorderRadius.circular(200),
        ) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

           icon != "" ? Image.asset(
              icon,
              height: 65,
              width: 65,
            ): const SizedBox(
             height: 65,
             width: 65,),
            title.text
                .color(AppColor.primary).bold
            .fontFamily(AppFonts.appFont)
            .base
                .align(TextAlign.center)
                .maxLines(2)
                .overflow(TextOverflow.ellipsis)
                .make(),
            10.heightBox,
          ],
        ).pSymmetric(h: 10),
      ),
    );
  }
}
