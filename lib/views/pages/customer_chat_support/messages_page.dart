import 'package:flutter/material.dart';
import 'package:mealknight/requests/order.request.dart';
import 'package:mealknight/views/pages/customer_chat_support/customer_chat_support.dart';
import '../../../constants/app_colors.dart';
import '../../../models/ticket_list_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tickets available.'));
          } else {
            return ListView.builder(
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
                      title: Text(
                        ticket.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        'Order Number: ${ticket.orderNumber}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
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
            );
          }
        },
      ),
    );
  }
}
