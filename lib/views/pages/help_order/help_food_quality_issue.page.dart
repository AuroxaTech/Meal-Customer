import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_routes.dart';
import '../../../models/order.dart';
import '../../../widgets/base.page.dart';
import '../help_category/help_category.page.dart';

class HelpFoodQualityIssuePage extends StatefulWidget {
  final Order order;
  final String title;


   const HelpFoodQualityIssuePage({required this.order, super.key, required this.title});

  @override
  State<HelpFoodQualityIssuePage> createState() =>
      _HelpFoodQualityIssuePageState();
}
final TextEditingController _messageController = TextEditingController();

class _HelpFoodQualityIssuePageState extends State<HelpFoodQualityIssuePage> {
  bool isSubmitted = false;

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
                "Food Quality issue.",
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
                isSubmitted
                    ? "The restaurant has been notified of the issue. You may get in touch with the restaurant directly to seek out a resolution."
                    : "We are sorry to hear that you were not satisfied with the quality of the food you received. Unfortunately, we are not directly involved with the preparation of the order. However, you can leave comments for the restaurant or get in touch with them directly to seek out any resolution.",
                style: TextStyle(
                    fontFamily: AppFonts.appFont,
                    fontSize: 20,
                    color: AppColor.primaryColor),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            if (!isSubmitted) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Add notes for the store:",
                  style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      fontSize: 25,
                      color: AppColor.primaryColor),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 3.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child:  TextField(
                  controller: _messageController,
                  minLines: 4,
                  maxLines: 6,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
            ],
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: ()async {
                    if(isSubmitted){
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).popUntil(
                              (route) {
                            return route.settings.name == AppRoutes.homeRoute ||
                                route.isFirst;
                          },
                        );
                      }
                    }else {
                      setState(() {
                        isSubmitted = true;
                      });
                      try {
                        final response = await ticketRequest.createTicket(
                          orderId: widget.order.id,
                          itemIds: [],
                          isUser: 1,
                          message: _messageController.text.toString() == "" ?"Hello":_messageController.text.toString(), // Use the actual message from the controller
                          title: widget.title,
                          photoPaths: [],
                        );
                        print("Create Ticket Response =====> ${response.body}");  // Handle success
                      } catch (e) {
                        print("Error Creating Ticket =====> $e");  // Handle error
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColor.primaryColor, width: 3.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isSubmitted ? "Home" : "Next",
                          style: TextStyle(
                              fontFamily: AppFonts.appFont,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor),
                        ),
                        if (!isSubmitted) ...[
                          const SizedBox(
                            width: 4.0,
                          ),
                          Image.asset(
                            AppImages.swipeArrows,
                            height: 32,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                        ],
                      ],
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
