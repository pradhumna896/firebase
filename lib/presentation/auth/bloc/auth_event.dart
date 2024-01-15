import 'dart:typed_data';

class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  AuthLoginEvent({
    required this.email,
    required this.password,
  });
}

class AuthLogoutEvent extends AuthEvent {}

class AuthSignupEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String age;
  final String email;
  final String password;
  final Uint8List imageFile;
  AuthSignupEvent({
    required this.imageFile,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.age,
  });
}
