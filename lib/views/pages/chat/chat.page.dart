import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    required this.chatEntity,
    Key? key,
  }) : super(key: key);

  final ChatEntity chatEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          chatEntity.title ?? "",
        ),
      ),
      body: Center(child: Text("Under development")),
      /*body: ChatBody(
        entity: chatEntity,
      ).wFull(context),*/
    );
  }
}
