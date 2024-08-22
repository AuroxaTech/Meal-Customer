import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_routes.dart';
import '../../../models/order.dart';
import '../../../widgets/base.page.dart';

class HelpOrderTakingTooLongPage extends StatefulWidget {
  final Order order;

  const HelpOrderTakingTooLongPage({required this.order, super.key});

  @override
  State<HelpOrderTakingTooLongPage> createState() =>
      _HelpOrderTakingTooLongPageState();
}

class _HelpOrderTakingTooLongPageState
    extends State<HelpOrderTakingTooLongPage> {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.primaryColor, width: 3.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.order.vendor?.name ?? "",
                          style: TextStyle(
                              fontFamily: AppFonts.appFont,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor),
                        ),
                      ),
                      Text(
                        "${widget.order.total}\$",
                        style: TextStyle(
                            fontFamily: AppFonts.appFont,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    Jiffy.parse("${widget.order.createdAt}",
                            pattern: "yyyy-MM-dd HH:mm")
                        .format(pattern: "d MMM, y  EEEE"),
                    style: TextStyle(
                        fontFamily: AppFonts.appFont,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor),
                  ),
                  Text(
                    widget.order.code,
                    style: TextStyle(
                        fontFamily: AppFonts.appFont,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Delivery taking too long?',
                style: TextStyle(
                    fontFamily: AppFonts.appFont,
                    fontSize: 25,
                    color: AppColor.primaryColor),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
              child: Text(
                "We try to complete all orders promptly and in a timely manner BUT conditions on the road change frequently. Your restaurant may need more time to prepare your order or your delivery driver may be stuck in traffic. Whichever be the case, we have received your message and working on it. An agent has been assigned to follow this delivery and if your order is delayed by a substantial amount of time, we will automatically take steps to right any wrong.",
                style: TextStyle(
                    fontFamily: AppFonts.appFont,
                    fontSize: 20,
                    color: AppColor.primaryColor),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).popUntil(
                            (route) {
                          return route.settings.name == AppRoutes.homeRoute ||
                              route.isFirst;
                        },
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColor.primaryColor, width: 3.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Home",
                      style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            const SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}
