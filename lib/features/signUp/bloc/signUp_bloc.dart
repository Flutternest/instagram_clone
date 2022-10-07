import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/signUp/bloc/signUp_event.dart';
import 'package:instagram_clone/features/signUp/bloc/signUp_repository.dart';
import 'package:instagram_clone/features/signUp/bloc/signUp_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpRepository? signUpRepository;

  SignUpBloc({required this.signUpRepository}) : super(SignUpIdleState());

  @override
  SignUpState get initialState => SignUpIdleState();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (kDebugMode) {
      print("Event $event");
    }

    if (event is SigningUp) {
      yield SignUpInProgressState();
      if (kDebugMode) {
        print("in sign up bloc");
      }

      try {
        SignUpResponse? x = await signUpRepository?.signUp(
            email: event.email, password: event.password);
        yield SignUpSuccessState(success: x?.success, message: x?.message);
      } catch (e, st) {
        if (kDebugMode) {
          print("Exception in Sign Up $e, \n$st");
        }
        yield SignUpErrorState(message: e.toString());
      }
    }

    if (event is AddUser) {
      yield SignUpInProgressState();
      if (kDebugMode) {
        print("in sign up bloc");
      }

      try {
        SignUpResponse? x = await signUpRepository?.addUser(
            file: event.file,
            username: event.username,
            bio: event.bio,
            email: event.email);
        yield AddUserSuccessState(
            success: x?.success, message: "Signed up successfully");
      } catch (e, st) {
        if (kDebugMode) {
          print("Exception in Sign Up $e, \n$st");
        }
        yield SignUpErrorState(message: e.toString());
      }
    }
  }
}
