import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/firebase_repo/models/user.dart';
import 'package:instagram_clone/features/firebase_repo/user_repo.dart';
import 'package:instagram_clone/features/login/login.dart';
import 'package:instagram_clone/features/signUp/bloc/signUp_bloc.dart';
import 'package:instagram_clone/features/signUp/bloc/signUp_state.dart';
import 'package:instagram_clone/utils/app_messages.dart';
import 'package:instagram_clone/utils/asset_strings.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/signUp_event.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPassword = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode bioFocusNode = FocusNode();
  ValueNotifier<String> profileLink = ValueNotifier("");
  ValueNotifier<bool> gotProfilePhoto = ValueNotifier(false);
  late SignUpBloc signUpBloc;

  bool showLoader = false;
  List<File> files = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    signUpBloc = BlocProvider.of<SignUpBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image.asset(AssetStrings.instaImage,
                      height: MediaQuery.of(context).size.width * 0.16),
                  Stack(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: gotProfilePhoto,
                        builder: (context, value, _) {
                          return CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: files.isNotEmpty && value
                                  ? ClipOval(
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(35),
                                        child: Image.file(
                                          files[0],
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: AssetStrings.userImage,
                                      fit: BoxFit.fitWidth,
                                      progressIndicatorBuilder:
                                          (context, str, progress) {
                                        return const CupertinoActivityIndicator();
                                      },
                                      errorWidget: (context, str, _) {
                                        return const Center(
                                          child: Icon(Icons.person),
                                        );
                                      },
                                    ));
                        },
                      ),
                      Positioned(
                        bottom: -15,
                        right: -20,
                        child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false);
                              if (result != null) {
                                files = result.paths
                                    .map((path) => File(path!))
                                    .toList();
                                gotProfilePhoto.value = true;
                              }
                            },
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.edit,
                                  size: 15,
                                  color: Colors.white,
                                ))),
                      ),
                    ],
                  ),
                  Form(
                      child: Column(
                    children: [
                      _getEmailField,
                      _getPasswordField,
                      _getUsernameField,
                      _getBioField
                    ],
                  )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: ElevatedButton(
                        onPressed: () async {
                          signUp();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const Text("Sign Up")),
                  ),
                ],
              ),
            ),
            BlocListener<SignUpBloc, SignUpState>(
                child: const SizedBox(
                  height: 0,
                  width: 0,
                ),
                listener: (context, state) async {
                  if (state is SignUpInProgressState) {
                    showLoader = true;
                  } else {
                    showLoader = false;
                  }
                  if (state is SignUpErrorState) {
                    showAlert(
                        context: context,
                        title: "Error",
                        message: state.message,
                        onPressed: () {
                          Navigator.pop(context);
                        });
                  }

                  if (state is SignUpSuccessState) {
                    await addUserToFirebase();
                  }

                  if (state is AddUserSuccessState) {
                    showAlert(
                        context: context,
                        title: AppMessages.signUpSuccess,
                        message: state.message,
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const LoginScreen();
                          }), (route) => false);
                        });
                  }
                }),
            BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
              if (kDebugMode) {
                print("state----->$state");
              }
              return (showLoader)
                  ? const CupertinoActivityIndicator()
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    );
            }),
          ],
        ),
      ),
    );
  }

  addUserToFirebase() {
    signUpBloc.add(AddUser(
        file: files.isNotEmpty ? files[0] : File(""),
        username: usernameController.text,
        bio: bioController.text,
        email: emailController.text));
  }

  signUp() {
    signUpBloc.add(SigningUp(
        email: emailController.text, password: passwordController.text));
  }

  // Returns email field
  get _getEmailField {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: appThemedTextField(
        context: context,
        hint: "Email address",
        controller: emailController,
        obscureText: false,
        focusNode: emailFocusNode,
        // nextFocus: pwdFocusNode,
        onFieldSubmitted: (str) {},
        suffix: const Icon(Icons.visibility_off, color: Colors.transparent),
      ),
    );
  }

//Return password field
  get _getPasswordField {
    return appThemedTextField(
      context: context,
      hint: "Password",
      suffix: InkWell(
          child: Icon(
            showPassword == true ? Icons.visibility : Icons.visibility_off,
            color: showPassword ? Colors.blue : Colors.grey,
          ),
          onTap: () => setState(() {
                showPassword = !showPassword;
              })),
      controller: passwordController,
      obscureText: !showPassword,
      focusNode: passwordFocusNode,
      onFieldSubmitted: (text) {},
    );
  }

  // Returns username field
  get _getUsernameField {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: appThemedTextField(
        context: context,
        hint: "Username",
        controller: usernameController,
        obscureText: false,
        focusNode: usernameFocusNode,
        // nextFocus: pwdFocusNode,
        onFieldSubmitted: (str) {},
        suffix: const Icon(Icons.visibility_off, color: Colors.transparent),
      ),
    );
  }

  // Returns bio field
  get _getBioField {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: appThemedTextField(
        context: context,
        hint: "Bio",
        maxLines: 4,
        controller: bioController,
        obscureText: false,
        focusNode: bioFocusNode,
        // nextFocus: pwdFocusNode,
        onFieldSubmitted: (str) {},
        suffix: const Icon(Icons.visibility_off, color: Colors.transparent),
      ),
    );
  }

  // Returns "App themed text field" left sided label
  Widget appThemedTextField({
    required String hint,
    required TextEditingController controller,
    required BuildContext context,
    required bool obscureText,
    required FocusNode focusNode,
    int maxLines = 1,
    required Function(String) onFieldSubmitted,
    bool enabled = true,
    required Widget suffix,
  }) {
    const TextStyle defaultLabelStyle = TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    );
    final TextStyle defaultTextStyle = TextStyle(
      color: enabled ? Colors.black : Colors.black.withOpacity(0.6),
    );

    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[200],
            border: Border.all(color: (Colors.grey[400])!)),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
            left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: controller,
                obscureText: obscureText,
                focusNode: focusNode,
                onFieldSubmitted: onFieldSubmitted,
                style: defaultTextStyle,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hint,
                  labelStyle: defaultLabelStyle,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    top: 0.0,
                    bottom: 0.0,
                  ),
                  errorStyle: const TextStyle(
                    fontSize: 10.0,
                  ),
                  helperStyle: const TextStyle(
                    fontSize: 0.0,
                    color: Colors.black,
                  ),
                  isDense: true,
                ),
              ),
            ),
            suffix,
          ],
        ),
      ),
    );
  }

  //Method to show custom alert box
  showAlert({
    context,
    required String? message,
    title,
    isInfo = false,
    bool canCloseByBackButton = true,
    required Function() onPressed,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => canCloseByBackButton,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: const EdgeInsets.all(0.0),
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Stack(
              alignment: const AlignmentDirectional(0, 0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 38),
                  child: Container(
                    padding: const EdgeInsets.only(top: 26),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      //Body
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title ?? "",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            message ?? "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5))),
                            ),
                            onPressed: onPressed,
                            child: const Text(
                              "OK",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
