import 'package:push_notification/presentation/home/model/user_model.dart';

class HomeState{} 

class HomeInitialState extends HomeState{} 

class HomeLoadingState extends HomeState{}


class HomeLoadedState extends HomeState{
  final List<UserModel> users;
  HomeLoadedState({required this.users});
}

class HomeErrorState extends HomeState{
  final String message;
  HomeErrorState({required this.message});
}

class HomePostCreateState extends HomeState{}

