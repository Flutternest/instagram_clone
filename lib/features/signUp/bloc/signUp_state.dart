abstract class SignUpState {}

class SignUpIdleState extends SignUpState {}

class SignUpInProgressState extends SignUpState {}

class SignUpErrorState extends SignUpState {
  String message;

  SignUpErrorState({required this.message});
}

class SignUpSuccessState extends SignUpState {
  bool? success;
  String? message;

  SignUpSuccessState({required this.success, required this.message});
}

class AddUserSuccessState extends SignUpState {
  bool? success;
  String? message;

  AddUserSuccessState({required this.success, required this.message});
}
