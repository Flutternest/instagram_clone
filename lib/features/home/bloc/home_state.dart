abstract class HomeState {}

class HomeIdleState extends HomeState {}

class HomeProgressState extends HomeState {}

class HomeErrorState extends HomeState {
  String message;

  HomeErrorState({required this.message});
}

class PostSuccessState extends HomeState {}
