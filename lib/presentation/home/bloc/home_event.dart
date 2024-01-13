import 'dart:typed_data';

class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomePostCreateEvent extends HomeEvent {
  final String? title;
  final Uint8List image;
  HomePostCreateEvent({this.title, required this.image});
}
