import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/views/pages/customer_chat_support/messages_page.dart';
import 'package:mealknight/views/pages/help_category/help_category.page.dart';
import 'package:mealknight/views/pages/help_order/help_order.page.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../widgets/base.page.dart';

class HelpTypePage extends StatefulWidget {
  const HelpTypePage({super.key});

  @override
  State<HelpTypePage> createState() => _HelpTypePageState();
}

class _HelpTypePageState extends State<HelpTypePage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Need Help",
      showLeadingAction: true,
      showAppBar: true,
      elevation: 0,
      appBarColor: context.theme.colorScheme.surface,
      appBarItemColor: AppColor.primaryColor,
      backgroundColor: Colors.white,
      isBackground: false,
      actions: [
        Image.asset(AppImages.cashier),
      ],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                context.nextPage(
                  const HelpOrderPage(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColor.primaryColor, width: 3.0),
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 48.0,
                child: Text(
                  'Help with an order',
                  style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor),
                ),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            InkWell(
              onTap: (){
                context.nextPage(
                  const MessagesPage(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.primaryColor, width: 3.0),
                    borderRadius: BorderRadius.circular(15.0)),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 48.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 24.0,
                    ),
                    SizedBox(
                        width: 48.0, child: Image.asset(AppImages.chatBalloon)),
                    const SizedBox(
                      width: 24.0,
                    ),
                    Text(
                      'Messages',
                      style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
