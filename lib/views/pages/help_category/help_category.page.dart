import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/views/pages/help_order/help_food_quality_issue.page.dart';
import 'package:mealknight/views/pages/help_order/help_i_was_charged_twice.page.dart';
import 'package:mealknight/views/pages/help_order/help_missing_items.page.dart';
import 'package:mealknight/views/pages/help_order/help_order_never_arrived.page.dart';
import 'package:mealknight/views/pages/help_order/help_order_taking_too_long.dart';
import 'package:mealknight/views/pages/help_order/help_worng_order_delivered.page.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../models/order.dart';
import '../../../requests/order.request.dart';
import '../../../widgets/base.page.dart';

class HelpCategoryPage extends StatefulWidget {
  final Order order;

  const HelpCategoryPage({required this.order, super.key});

  @override
  State<HelpCategoryPage> createState() => _HelpCategoryPageState();
}
final ticketRequest = OrderRequest();

class _HelpCategoryPageState extends State<HelpCategoryPage> {
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
      body: Column(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                ),
                children: [
                  _helpItemView(
                      title: "Missing items",
                      onClick: () {
                        context.nextPage(
                          HelpMissingItemsPage(order: widget.order, title: 'Missing items',),
                        );
                      }),
                  _helpItemView(
                      title: "Wrong Order Delivered",
                      onClick: () {
                        context.nextPage(
                          HelpWrongOrderDeliveredPage(order: widget.order, title: 'Wrong Order Delivered',),
                        );
                      }),
                  _helpItemView(
                      title: "Order Never Arrived",
                      onClick: () async{
                        context.nextPage(
                          HelpOrderNeverArrivedPage(order: widget.order),
                        );
                        try {
                          final response = await ticketRequest.createTicket(
                            orderId: widget.order.id,
                            itemIds: [],
                            isUser: 1,
                            message: "Hello", // Use the actual message from the controller
                            title: "Order Never Arrived",
                            photoPaths: [],
                          );
                          print("Create Ticket Response =====> ${response.body}");  // Handle success
                        } catch (e) {
                          print("Error Creating Ticket =====> $e");  // Handle error
                        }
                      }),
                  _helpItemView(
                      title: "Food Quality Issue",
                      onClick: () {
                        context.nextPage(
                          HelpFoodQualityIssuePage(order: widget.order, title: 'Food Quality Issue',),
                        );
                      }),
                  _helpItemView(
                      title: "Order Taking Too long",
                      onClick: ()async {
                        context.nextPage(
                          HelpOrderTakingTooLongPage(order: widget.order),
                        );
                        try {
                          final response = await ticketRequest.createTicket(
                            orderId: widget.order.id,
                            itemIds: [],
                            isUser: 1,
                            message: "Hello", // Use the actual message from the controller
                            title: "Order Taking Too long",
                            photoPaths: [],
                          );
                          print("Create Ticket Response =====> ${response.body}");  // Handle success
                        } catch (e) {
                          print("Error Creating Ticket =====> $e");  // Handle error
                        }
                      }),
                  _helpItemView(
                      title: "I was  Charged Twice!",
                      onClick: ()async {
                        context.nextPage(
                          HelpIWasChargedTwicePage(order: widget.order),
                        );
                        try {
                          final response = await ticketRequest.createTicket(
                            orderId: widget.order.id,
                            itemIds: [],
                            isUser: 1,
                            message: "Hello", // Use the actual message from the controller
                            title: "I was  Charged Twice!",
                            photoPaths: [],
                          );
                          print("Create Ticket Response =====> ${response.body}");  // Handle success
                        } catch (e) {
                          print("Error Creating Ticket =====> $e");  // Handle error
                        }
                      }),
                  _helpItemView(title: "Payment issue", onClick: () {}),
                  _helpItemView(title: "Promotion Issue", onClick: () {}),
                  _helpItemView(title: "It’s something else", onClick: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _helpItemView({required String title, VoidCallback? onClick}) {
    return InkWell(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(color: AppColor.primaryColor, width: 3.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
