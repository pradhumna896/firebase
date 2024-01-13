class AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginFailed extends AuthState {
  final String message;
  AuthLoginFailed(this.message);
}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFailed extends AuthState {}

class AuthSignupSuccess extends AuthState {}

class AuthSignupFailed extends AuthState {
  final String message;
  AuthSignupFailed(this.message);
}

class AuthStateInitial extends AuthState {

}
