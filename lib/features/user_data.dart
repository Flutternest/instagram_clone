class UserData {
  late String userId;
  late String username;
  late String profilePhoto;
  late String bio;

  static final UserData _inst = UserData._internal();

  UserData._internal();

  factory UserData() => _inst;
}
