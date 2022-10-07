abstract class LoginEvent {
  const LoginEvent();
}

class LoggingIn extends LoginEvent {
  String email;
  String password;
  LoggingIn({required this.email, required this.password});
}
