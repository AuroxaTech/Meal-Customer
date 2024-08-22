import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_colors.dart';
import '../../../models/ticket_list_model.dart';
import '../../../requests/order.request.dart';

class CustomerChatSupport extends StatefulWidget {
  final int? ticketId;
  final int? index;
  final List<Message>? messages;
  final bool? isChatClosed;

  const CustomerChatSupport({
    super.key,
    this.ticketId,
    this.index,
    this.messages,
    this.isChatClosed = false,
  });

  @override
  State<CustomerChatSupport> createState() => _CustomerChatSupportState();
}

class _CustomerChatSupportState extends State<CustomerChatSupport> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;

  List<Message> messages = [];
  bool isChatClosed = false;
  late Future<List<Message>> _messagesFuture;
  bool _isLoadingMessages = true;
  bool _isSendingMessage = false;

  Future<List<Message>> _fetchMessagesFromTickets() async {
    List<Ticket> tickets = await OrderRequest().getTickets();
    List<Message> messages = tickets[widget.index!].messages;
    return messages;
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadChatClosedStatus();
  }

  void _loadMessages() async {
    setState(() {
      _isLoadingMessages = true;
    });

    final fetchedMessages = await _fetchMessagesFromTickets();
    setState(() {
      messages = fetchedMessages;
      _isLoadingMessages = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  void _loadChatClosedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isChatClosed = prefs.getBool('isChatClosed') ?? false;
    });
  }

  void _sendMessage() async {
    if (_selectedImage != null || _controller.text.isNotEmpty) {
      final messageText = _controller.text.isNotEmpty ? _controller.text : "";

      setState(() {
        _isSendingMessage = true;
      });

      try {
        final newMessage = await OrderRequest().replyToTicket(
          ticketId: widget.ticketId,
          message: messageText,
          isUser: true,
          isAdmin: false,
          isVendor: false,
          photo: _selectedImage,
        );

        _loadMessages();
        // Refresh the messages after sending
        setState(() {
          _controller.clear();
          _isSendingMessage = false;
          _selectedImage = null;
        });
      } catch (e) {
        setState(() {
          _isSendingMessage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message or image cannot be empty.')),
      );
    }
  }

  void _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "";
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(timestamp);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    final DateFormat dateFormatter = DateFormat('MMMM d, yyyy');
    return dateFormatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              itemCount: messages.length + (isChatClosed ? 1 : 0),
              itemBuilder: (context, index) {
                final reversedMessages = messages.reversed.toList();

                if (index == reversedMessages.length && isChatClosed) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Chat has been closed.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final message = reversedMessages[index];
                bool isUser = message.isUser;
                bool isAdminOrVendor = message.isAdmin ||message.isVendor ;
                final timestamp = message.createdAt;

                bool showDate = false;
                if (index == 0 || _formatDate(timestamp) != _formatDate(reversedMessages[index - 1].createdAt)) {
                  showDate = true;
                }

                return Column(
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _formatDate(timestamp),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(

                        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (message.photo != null && message.photo!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: message.photo!.startsWith('http')
                                  ? Container(
                                height: 250,
                                width: 250,
                                decoration:BoxDecoration(
                                    border: Border.all(color: AppColor.primaryColor,width: 5),
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(image: NetworkImage(message.photo!,),
                                      fit: BoxFit.cover,
                                    )
                                ),
                              )
                                  : Image.file(
                                File(message.photo!),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (message.message.isNotEmpty)
                            isAdminOrVendor? Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                              child: Text(
                                message.isAdmin?"Admin":"Vendor",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ):const SizedBox(),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            constraints: const BoxConstraints(maxWidth: 200),
                            decoration: BoxDecoration(
                              color: isUser ? AppColor.primaryColor : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              message.message,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                            child: Text(
                              _formatTimestamp(timestamp),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (!isChatClosed)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    _selectedImage == null ?SizedBox() :    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                            height: 80,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,width: 1),
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(image: FileImage(_selectedImage!),
                              fit: BoxFit.cover
                              )
                            ),
                          ),
                    ),SizedBox(height: 5,),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Write a message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  _isSendingMessage ? const CircularProgressIndicator() : Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: _selectImage,
                      ),
                    ],
                  ),
                ],
              ),
            ),

        ],
      ),
    );
  }
}
