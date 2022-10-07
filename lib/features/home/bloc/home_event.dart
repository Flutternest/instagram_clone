import 'dart:io';

abstract class HomeEvent {
  const HomeEvent();
}

class AddPostEvent extends HomeEvent {
  File file;
  String caption;
  AddPostEvent({required this.file, required this.caption});
}
