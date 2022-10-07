import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/login/bloc/login_event.dart';
import 'package:instagram_clone/features/login/bloc/login_repository.dart';
import 'package:instagram_clone/features/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LogInState> {
  LogInRepository? loginRepository;

  LoginBloc({required this.loginRepository}) : super(LogInIdleState());

  @override
  LogInState get initialState => LogInIdleState();

  @override
  Stream<LogInState> mapEventToState(LoginEvent event) async* {
    print("Event $event");

    if (event is LoggingIn) {
      yield LogInProgressState();

      try {
        LogInResponse x = await loginRepository?.logIn(
            email: event.email, password: event.password);
        yield LogInSuccessState(success: x.success, message: x.message);
      } catch (e, st) {
        print("Exception in Sign Up $e, \n$st");
        yield LogInErrorState(message: e.toString());
      }
    }
  }
}
