abstract class LogInState {}

class LogInIdleState extends LogInState {}

class LogInProgressState extends LogInState {}

class LogInErrorState extends LogInState {
  String message;

  LogInErrorState({required this.message});
}

class LogInSuccessState extends LogInState {
  bool success;
  String message;

  LogInSuccessState({required this.success, required this.message});
}
