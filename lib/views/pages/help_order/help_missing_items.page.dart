import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_routes.dart';
import '../../../models/order.dart';
import '../../../models/order_product.dart';
import '../../../requests/order.request.dart';
import '../../../widgets/base.page.dart';
import 'firebasefirestore.dart';

class HelpMissingItemsPage extends StatefulWidget {
  final String title;
  final Order order;

   HelpMissingItemsPage({required this.order,required this.title, super.key});

  @override
  State<HelpMissingItemsPage> createState() => _HelpMissingItemsPageState();
}

class _HelpMissingItemsPageState extends State<HelpMissingItemsPage> {
  final TextEditingController _messageController = TextEditingController();
  int submitLevel = 0;
  final ticketRequest = OrderRequest();
  List<int> ids = [];
  List<OrderProduct> displayOrderProducts = [];

  @override
  void initState() {
    super.initState();
    // Create a separate list for display purposes to avoid modifying the original list
    for (OrderProduct orderProduct in widget.order.orderProducts ?? []) {
      for (int i = 0; i < orderProduct.quantity; i++) {
        displayOrderProducts.add(orderProduct.copy());
      }
    }
  }

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
                submitLevel == 0
                    ? "Select the missing items:"
                    : submitLevel == 1
                        ? "Missing Items"
                        : "",
                style: TextStyle(
                    fontFamily: AppFonts.appFont,
                    fontSize: 25,
                    color: AppColor.primaryColor),
              ),
            ),
            if (submitLevel == 0)
              for (OrderProduct product in displayOrderProducts)
                ListTile(
                  title: Text(
                    product.product?.name ?? "",
                    style: TextStyle(
                      color: AppColor.primaryColor,
                    ),
                  ),
                  leading: Checkbox(
                    value: product.isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        product.isSelected = value ?? false;
                        if (value == true) {
                          ids.add(product.id);
                        }
                      });
                      print("Id =======> ${product.id}");
                    },
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (String option in product.options?.split(",") ?? [])
                        Text(
                          "    1 x $option",
                          style: TextStyle(
                            color: AppColor.primaryColor,
                          ),
                        ),
                    ],
                  ),
                )
            else if (submitLevel == 1)
              for (OrderProduct product in displayOrderProducts)
                if (product.isSelected)
                  ListTile(
                    title:
                    Text(
                      "${product.product?.name}",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                      ),
                    ),
                    /*trailing: Text(
                      "${product.price}\$",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                      ),
                    ),*/
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (String option in product.options?.split(",") ?? [])
                          Text(
                            "    1x $option",
                            style: TextStyle(
                              color: AppColor.primaryColor,
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  SizedBox.shrink()
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                child: Text(
                  "We have notified the store and we are working with them and the delivery partner to solve this right away. You will be contacted/notified soon.\n\n\nPlease allow 5-15 minutes as the store might be busy during some hours. Rest assured the issue is being dealt with the highest of urgency and we appreciate allowing us the chance to correct any mistake.",
                  style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      fontSize: 20,
                      color: AppColor.primaryColor),
                ),
              ),
            const SizedBox(
              height: 20.0,
            ),
            if (submitLevel == 1) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Add notes for the store(required):",
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
                  onTap: () async {
                    if (submitLevel == 2) {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).popUntil(
                              (route) {
                            return route.settings.name == AppRoutes.homeRoute || route.isFirst;
                          },
                        );
                      }
                    } else {
                      bool canContinue = false;
                      if (submitLevel == 0) {
                        for (OrderProduct product in widget.order.orderProducts ?? []) {
                          if (product.isSelected) {
                            // Assuming this loop checks if any product is selected
                          }
                        }
                        setState(() {
                          canContinue = true;
                        });
                      } else {
                        canContinue = true;
                      }
                      if (canContinue) {
                        // Check if the message is empty
                        if (_messageController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please add a note for the store"),
                            ),
                          );
                          // Ensure submitLevel remains 1
                          setState(() {
                            submitLevel = 1;
                          });
                          return;
                        }

                        // If the message is not empty, proceed
                        setState(() {
                          submitLevel = 2;
                          print("Submit level =====> $submitLevel");
                        });

                        if (submitLevel == 2) {  // Check the flag
                          try {
                            final response = await ticketRequest.createTicket(
                              orderId: widget.order.id,
                              itemIds: ids,
                              isUser: 1,
                              message: _messageController.text, // Use the actual message from the controller
                              title: widget.title,
                              photoPaths: [],
                            );
                            print("Item Ids =====> $ids");  // Handle success
                            print("Create Ticket Response =====> ${response.body}");  // Handle success
                          } catch (e) {
                            print("Error Creating Ticket =====> $e");  // Handle error
                          } finally {
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select product(s)"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.primaryColor, width: 3.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          submitLevel == 2 ? "Home" : "Next",
                          style: TextStyle(
                            fontFamily: AppFonts.appFont,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        if (submitLevel != 2) ...[
                          const SizedBox(width: 4.0),
                          Image.asset(
                            AppImages.swipeArrows,
                            height: 32,
                          ),
                          const SizedBox(width: 4.0),
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

