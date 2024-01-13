import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notification/presentation/home/bloc/home_event.dart';
import 'package:push_notification/presentation/home/bloc/home_state.dart';
import 'package:push_notification/presentation/home/model/user_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  HomeBloc() : super(HomeInitialState()) {
    on<HomeInitialEvent>(_getUser);
    on<HomePostCreateEvent>(_addNewPost);
  }

  FutureOr<void> _getUser(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      var users = await firestore.collection("users").orderBy('age').get();
      List<UserModel> usersList = [];
      users.docs.forEach((element) {
        usersList.add(UserModel.fromJson(element.data()));
      });
      emit(HomeLoadedState(users: usersList));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _addNewPost(
      HomePostCreateEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final image = await getImage(event.image);
      await firestore.collection("posts").add({
        "title": event.title,
        "post": image,
        "createdBy": auth.currentUser!.email,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "likes": [],
        "comments": []
      });
      emit(HomePostCreateState());
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<String> getImage(Uint8List file) async {
    var ref = storage.ref().child("images");
    var uploadTask = await ref.putData(file);
    var downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }
}
