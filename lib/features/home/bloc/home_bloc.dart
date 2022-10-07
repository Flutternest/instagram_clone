import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_repository.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository? homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeIdleState());

  HomeState get initialState => HomeIdleState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (kDebugMode) {
      print("Event $event");
    }

    if (event is AddPostEvent) {
      yield HomeProgressState();

      try {
        var x = await homeRepository?.addPost(
            file: event.file, caption: event.caption);
        yield PostSuccessState();
      } catch (e, st) {
        if (kDebugMode) {
          print("Exception in Sign Up $e, \n$st");
        }
        yield HomeErrorState(message: e.toString());
      }
    }
  }
}
