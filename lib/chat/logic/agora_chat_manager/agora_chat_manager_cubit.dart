import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_sdk_engine/chat/models/chat_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'agora_chat_manager_state.dart';

class AgoraChatConfig {
  static const String appKey = "61877991#1058486";
  static const String userId = "pixel";
  static const String agoraToken =
      "007eJxTYFg2w3ilmF7U5/bjRZazL02d6HioO3F3GJfZCkMVD5VFudwKDMmmhqbJFqlJacbGhiZpaRaWhkYWFkmJKQZGhsbm5iYG8wUPJjcEMjJs/KLJwsjAysAIhCC+CoNZqoGFhaGxga6lsaGlrqFhaopuorlpiq6RsUmKZYpBioFlUgoAtQQlIw==";
}

class AgoraChatManagerCubit extends Cubit<AgoraChatManagerState> {
  AgoraChatManagerCubit() : super(const AgoraChatManagerState(chats: []));

  final List<ChatModel> _chatLog = [];

  List<ChatModel> get chats => _chatLog;

  void emitMessage() async {
    if (isClosed) {
      return;
    }

    emit(state.copyWith(chats: chats));
  }

  void initSDK() async {
    ChatOptions options = ChatOptions(
      appKey: AgoraChatConfig.appKey,
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);

    //Init listener
    _addChatListener();
  }

  void signIn() async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        AgoraChatConfig.userId,
        AgoraChatConfig.agoraToken,
      );
      Fluttertoast.showToast(
          msg: "login succeed, userId: ${AgoraChatConfig.userId}");
    } on ChatError catch (e) {
      Fluttertoast.showToast(
          msg: "login failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      Fluttertoast.showToast(msg: "Sign out succeed");
    } on ChatError catch (e) {
      Fluttertoast.showToast(
          msg: "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void sendMessage({
    required String message,
    required String receiverId,
  }) async {
    // if (_chatId == null || _messageContent == null) {
    //   _addLogToConsole("single chat id or message content is null");
    //   return;
    // }
    var msg = ChatMessage.createTxtSendMessage(
      targetId: receiverId,
      content: message,
    );
    // msg.setMessageStatusCallBack(MessageStatusCallBack(
    //   onSuccess: () {
    //     _chatLog
    //         .add(ChatModel(text: message, isLocalUser: true, userName: 'You'));

    //     emitMessage();
    //   },
    //   onError: (e) {
    //     Fluttertoast.showToast(
    //         msg:
    //             "send message failed, code: ${e.code}, desc: ${e.description}");
    //   },
    // ));
    Fluttertoast.showToast(
        msg: "send message failed, code: e." );

    ChatClient.getInstance.chatManager.sendMessage(msg);
  }

  void _addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: _onMessagesReceived),
    );
  }

  void _onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;

            _chatLog.add(ChatModel(
              text: body.content,
              isLocalUser: false,
              userName: msg.from ?? "User",
            ));
            // _addLogToConsole(
            //   "receive text message: ${body.content}, from: ${msg.from}",
            // );
          }
          break;

        case MessageType.IMAGE:
          {}
          break;
        case MessageType.VIDEO:
          {}
          break;
        case MessageType.LOCATION:
          {}
          break;
        case MessageType.VOICE:
          {}
          break;
        case MessageType.FILE:
          {}
          break;
        case MessageType.CUSTOM:
          {}
          break;
        case MessageType.CMD:
          {}
          break;
      }
    }
    emitMessage();
  }
}
