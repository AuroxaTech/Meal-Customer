import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mealknight/requests/order.request.dart';
import 'package:mealknight/views/pages/customer_chat_support/customer_chat_support.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../models/ticket_list_model.dart';
import '../../../view_models/orders.vm.dart';
import '../../../widgets/states/loading.shimmer.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late Future<List<Ticket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = OrderRequest().getTickets();
  }
  Future<void> _refreshTickets() async {
    setState(() {
      _ticketsFuture = OrderRequest().getTickets();
    });
    // Wait for the future to complete before finishing the refresh
    await _ticketsFuture;
  }
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      title: 'Messages',
      showLeadingAction: true,
      elevation: 0,
      centerTitle: true,
      appBarColor: context.theme.colorScheme.background,
      appBarItemColor: AppColor.primaryColor,
      backgroundColor: const Color(0xffeefffd),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  const LoadingShimmer();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tickets available.'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshTickets,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ticket = snapshot.data![index];
                  return  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primaryColor, width: 3.0),
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            ticket.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'Order Number: ${ticket.orderNumber}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerChatSupport(
                                ticketId: ticket.id,
                                messages: ticket.messages,
                                isChatClosed: ticket.isClosed,
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
