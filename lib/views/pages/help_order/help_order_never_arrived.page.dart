import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_routes.dart';
import '../../../models/order.dart';
import '../../../models/user.dart';
import '../../../services/auth.service.dart';
import '../../../widgets/base.page.dart';

class HelpOrderNeverArrivedPage extends StatefulWidget {
  final Order order;

  const HelpOrderNeverArrivedPage({required this.order, super.key});

  @override
  State<HelpOrderNeverArrivedPage> createState() =>
      _HelpOrderNeverArrivedPageState();
}

class _HelpOrderNeverArrivedPageState extends State<HelpOrderNeverArrivedPage> {
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
                'Order never received.',
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
                "We have notified the store and your order is being re-prepared with the utmost urgency. You will receive updated tracking information on your app soon.",
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
                const SizedBox(
                  width: 20.0,
                ),
                InkWell(
                  onTap: () async {
                    User currentUser =
                        await AuthServices.getCurrentUser(force: true);
                    final user = PeerUser(
                        id: currentUser.id.toString(),
                        name: currentUser.name,
                        image: currentUser.photo);
                    final admin = PeerUser(id: "admin", name: "Admin");
                    final peers = {
                      currentUser.id.toString(): user,
                      "admin": admin,
                    };

                    final chatEntity = ChatEntity(
                      mainUser: user,
                      peers: peers,
                      path: "sport/${widget.order.code}",
                      title: widget.order.vendor?.name ?? "Order never arrived",
                      supportMedia: true,
                      onMessageSent: (String message, ChatEntity chatEntity) {
                        //handle when chat has been sent to firestore
                        //you can use it to send notification or show a toast/snakbar
                      },
                    );

                    Navigator.push(
                      context,
                      FirestoreChat().chatPageWidget(chatEntity),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColor.primaryColor, width: 3.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Chat Support",
                      style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor),
                    ),
                  ),
                ),
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
