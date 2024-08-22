import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_routes.dart';
import '../../../models/order.dart';
import '../../../requests/order.request.dart';
import '../../../widgets/base.page.dart';

class HelpWrongOrderDeliveredPage extends StatefulWidget {
  final Order order;
  final String title;

  const HelpWrongOrderDeliveredPage({required this.order, super.key, required this.title});

  @override
  State<HelpWrongOrderDeliveredPage> createState() =>
      _HelpWrongOrderDeliveredPageState();
}

class _HelpWrongOrderDeliveredPageState
    extends State<HelpWrongOrderDeliveredPage> {
  bool isSubmitted = false;
  List<String> imageNames = [];
  List<File> imagePaths = [];
  final ticketRequest = OrderRequest();

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
                "Wrong order received.",
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
                    ? "We have notified the store and your order is being re-prepared with the utmost urgency. You will receive updated tracking information on your app soon."
                    : "Although mistakes are rare, they do happen. We apologize for the inconvenience. Please upload a picture of what you received.",
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 3.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final imagePicker = ImagePicker();
                        final pickedFile = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            imagePaths.add(File(pickedFile.path)); // Convert XFile to File
                            imageNames.add(pickedFile.name);
                          });
                        }
                      },
                      child: Text(
                        "Upload up to 5 pictures",
                        style: TextStyle(
                            fontFamily: AppFonts.appFont,
                            fontSize: 18,
                            color: AppColor.primaryColor),
                      ),
                    ),
                    if (imagePaths.isEmpty)
                      const SizedBox(
                        height: 128.0,
                      )
                    else
                      for (File imagePath in imagePaths)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.file(imagePath),
                        ),
                  ],
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
                  onTap: () async {
                    if (isSubmitted) {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).popUntil(
                              (route) {
                            return route.settings.name == AppRoutes.homeRoute ||
                                route.isFirst;
                          },
                        );
                      }
                    } else {
                      setState(() {
                        isSubmitted = true;
                      });
                      if (isSubmitted == true) {
                        try {
                          final response = await ticketRequest.createTicket(
                            orderId: widget.order.id,
                            itemIds: [],
                            isUser: 1,
                            message: "Hello!",
                            title: widget.title,
                            photoPaths: imagePaths,
                          );
                          print(
                              "Create Ticket Response =====> ${response.message}"); // Handle success
                        } catch (e) {
                          print("Error Creating Ticket =====> $e"); // Handle error
                        }
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
