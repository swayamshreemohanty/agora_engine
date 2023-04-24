// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'agora_chat_manager_cubit.dart';

class AgoraChatManagerState extends Equatable {
  final List<ChatModel> chats;
  const AgoraChatManagerState({required this.chats});

  @override
  List<Object> get props => [chats];

  AgoraChatManagerState copyWith({required List<ChatModel> chats}) {
    List<ChatModel> newChats = [];
    newChats.addAll(chats);
    return AgoraChatManagerState(chats: newChats);
  }
}
