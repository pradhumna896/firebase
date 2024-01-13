import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notification/presentation/chat/bloc/chat_event.dart';
import 'package:push_notification/presentation/chat/bloc/chat_state.dart';
import 'package:push_notification/presentation/chat/chat_model.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ChatBloc() : super(ChatInitialState()) {
    on<ChatInitialEvent>(_getChat);
  }

  FutureOr<void> _getChat(
      ChatInitialEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      var chats = await firestore.collection("chats").get();
      List<ChatModel> chatsList = [];
      chats.docs.forEach((element) {
        chatsList.add(ChatModel.fromJson(element.data()));
      });
      emit(ChatLoadedState(chats: chatsList));
    } catch (e) {
      emit(ChatErrorState(message: e.toString()));
    }
  }
}
