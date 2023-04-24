// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final void Function(String message) onSendMessage;
  const NewMessage({
    Key? key,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  NewMessageState createState() => NewMessageState();
}

class NewMessageState extends State<NewMessage> {
  final messageTextController = TextEditingController();

  Future<void> _sendMessage() async {
    widget.onSendMessage.call(messageTextController.text.trim());
    FocusScope.of(context).unfocus();
    messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              controller: messageTextController,
              decoration: const InputDecoration(labelText: 'Send a message'),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed:
                messageTextController.text.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
