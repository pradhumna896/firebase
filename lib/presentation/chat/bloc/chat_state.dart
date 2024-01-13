import 'package:push_notification/presentation/chat/chat_model.dart';

class ChatState{} 

class ChatInitialState extends ChatState{} 

class ChatLoadingState extends ChatState{}

class ChatLoadedState extends ChatState{
  final List<ChatModel> chats;
  ChatLoadedState({required this.chats});
}



class ChatErrorState extends ChatState{
  final String message;
  ChatErrorState({required this.message});
}