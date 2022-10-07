import 'dart:io';

abstract class SignUpEvent {
  const SignUpEvent();
}

class SigningUp extends SignUpEvent {
  String email;
  String password;
  SigningUp({required this.email, required this.password});
}

class AddUser extends SignUpEvent {
  File file;
  String username;
  String bio;
  String email;
  AddUser(
      {required this.file,
      required this.username,
      required this.bio,
      required this.email});
}
