import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_sdk_engine/chat/logic/agora_chat_manager/agora_chat_manager_cubit.dart';
import 'package:agora_sdk_engine/communication/widget/chat/message_bubble.dart';
import 'package:agora_sdk_engine/communication/widget/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final clientIdTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AgoraChatManagerCubit>().initSDK();
  }

  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            const Text("login userId: ${AgoraChatConfig.userId}"),
            // const Text("agoraToken: ${AgoraChatConfig.agoraToken}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () =>
                        context.read<AgoraChatManagerCubit>().signIn(),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: const Text("SIGN IN"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () =>
                        context.read<AgoraChatManagerCubit>().signOut(),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: const Text("SIGN OUT"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: clientIdTextController,
              decoration: const InputDecoration(
                hintText: "Enter recipient's userId",
              ),
            ),
            Expanded(
              child: BlocConsumer<AgoraChatManagerCubit, AgoraChatManagerState>(
                listener: (context, state) {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                },
                builder: (context, state) {
                  final chats = state.chats;
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: chats.length,
                    itemBuilder: (ctx, index) => MessageBubble(
                      message: chats[index].text,
                      isLocalUser: chats[index].isLocalUser,
                      userName: chats[index].userName,
                    ),
                  );
                },
              ),
            ),
            NewMessage(
              onSendMessage: (message) {
                if (clientIdTextController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Client Id required",
                    gravity: ToastGravity.CENTER,
                  );
                  return;
                }
                context.read<AgoraChatManagerCubit>().sendMessage(
                    message: message,
                    receiverId: clientIdTextController.text.trim());
              },
            ),
          ],
        ),
      ),
    );
  }

  // void _addLogToConsole(String log) {
  //   // _logText.add("$_timeString: $log");
  //   _logText.add(ChatModel(text: log, isLocalUser: true));
  //   setState(() {
  //     scrollController.jumpTo(scrollController.position.maxScrollExtent);
  //   });
  // }

  // String get _timeString {
  //   return DateTime.now().toString().split(".").first;
  // }
}
