import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/dashboard.dart';
import 'package:instagram_clone/features/login/bloc/login_bloc.dart';
import 'package:instagram_clone/features/login/bloc/login_event.dart';
import 'package:instagram_clone/features/login/bloc/login_state.dart';
import 'package:instagram_clone/features/signUp/signUp.dart';
import 'package:instagram_clone/utils/app_messages.dart';
import 'package:instagram_clone/utils/asset_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  late LoginBloc loginBloc;
  bool showLoader = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginBloc = BlocProvider.of<LoginBloc>(context);
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
            Container(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image.asset(AssetStrings.instaImage,
                      height: MediaQuery.of(context).size.width * 0.16),
                  Form(
                      child: Column(
                    children: [
                      _getEmailField,
                      _getPasswordField,
                    ],
                  )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: ElevatedButton(
                        onPressed: () {
                          logIn();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const Text("Log In")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Forgotten your login details?",
                          style: TextStyle(color: Colors.grey[700])),
                      TextSpan(
                          text: " Get help with logging in?",
                          style: TextStyle(
                              color: Colors.indigo[700],
                              fontWeight: FontWeight.w500)),
                    ])),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          // width: MediaQuery.of(context).size.width / 2,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      Text(
                        "  OR  ",
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      Expanded(
                        child: Container(
                          // width: MediaQuery.of(context).size.width / 2,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.facebook),
                            Text("  Log In With Facebook"),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.grey[300],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(color: Colors.grey[700])),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return const SignUpScreen();
                              })),
                        text: " Sign up.",
                        style: TextStyle(
                            color: Colors.indigo[700],
                            fontWeight: FontWeight.w500)),
                  ])),
                ),
              ],
            ),
            BlocListener<LoginBloc, LogInState>(
                child: const SizedBox(
                  height: 0,
                  width: 0,
                ),
                listener: (context, state) async {
                  if (state is LogInProgressState) {
                    showLoader = true;
                  } else {
                    showLoader = false;
                  }
                  if (state is LogInErrorState) {
                    showAlert(
                        context: context,
                        title: "Error",
                        message: state.message,
                        onPressed: () {
                          Navigator.pop(context);
                        });
                  }

                  if (state is LogInSuccessState) {
                    showAlert(
                        context: context,
                        title: AppMessages.logInSuccess,
                        message: state.message,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const DashboardScreen();
                          }), (route) => false);
                        });
                  }
                }),
            BlocBuilder<LoginBloc, LogInState>(builder: (context, state) {
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

  logIn() {
    loginBloc.add(LoggingIn(
        email: emailController.text, password: passwordController.text));
  }

  // Returns email field
  get _getEmailField {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: appThemedTextField(
        context: context,
        hint: "Phone number, email address or username",
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: appThemedTextField(
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
                maxLines: 1,
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
}
