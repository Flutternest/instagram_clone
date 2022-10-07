import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/firebase_repo/post_repo.dart';
import 'package:instagram_clone/features/home/bloc/home_bloc.dart';
import 'package:instagram_clone/features/home/bloc/home_event.dart';
import 'package:instagram_clone/features/home/bloc/home_state.dart';
import 'package:instagram_clone/features/user_data.dart';
import 'package:instagram_clone/utils/asset_strings.dart';
import 'package:instagram_clone/utils/reusable_widgets.dart';
import '../firebase_repo/models/post.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PostDataRepository repository = PostDataRepository();
  UserData userData = UserData();
  List<File> files = [];
  ValueNotifier<bool> gotPost = ValueNotifier(false);
  TextEditingController captionController = TextEditingController();
  FocusNode captionFocusNode = FocusNode();
  late HomeBloc homeBloc;
  bool showLoader = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          AssetStrings.instaImage,
          height: MediaQuery.of(context).size.width * 0.1,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showPostDialog(context: context);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 5),
            child: Icon(
              Icons.messenger_outline_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReusableWidgets.storyItem(
                          username: 'Your story',
                          online: true,
                          userImage: userData.profilePhoto),
                      ReusableWidgets.storyItem(
                          username: 'user1xdfdfgrt',
                          userImage: AssetStrings.userProfile2),
                      ReusableWidgets.storyItem(
                          username: 'user2fdgryrtdf',
                          userImage: AssetStrings.userProfile3),
                      ReusableWidgets.storyItem(
                          username: 'user3knghghj',
                          userImage: AssetStrings.userProfile4),
                      ReusableWidgets.storyItem(
                          username: 'ctrl1223',
                          userImage: AssetStrings.userProfile5),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: repository.getStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CupertinoActivityIndicator();
                      }
                      return _buildList(context, snapshot.data?.docs ?? []);
                    }),
              ),
            ],
          ),
          BlocListener<HomeBloc, HomeState>(
              child: const SizedBox(
                height: 0,
                width: 0,
              ),
              listener: (context, state) async {
                if (state is HomeProgressState) {
                  showLoader = true;
                } else {
                  showLoader = false;
                }
                if (state is HomeErrorState) {
                  showAlert(
                      context: context,
                      title: "Error",
                      message: state.message,
                      onPressed: () {
                        Navigator.pop(context);
                      });
                }

                if (state is PostSuccessState) {
                  files.clear();
                  gotPost.value = false;
                  captionController.clear();
                }
              }),
          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
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

  // Returns caption field
  get _getCaptionField {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: appThemedTextField(
        context: context,
        hint: "Write a caption...",
        controller: captionController,
        obscureText: false,
        focusNode: captionFocusNode,
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

    return Container(
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(5),
          color: Colors.grey[200],
          border: Border.all(color: (Colors.grey[400])!)),
      alignment: Alignment.center,
      padding:
          const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
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
    );
  }

  //Method to show custom alert box
  showPostDialog({
    required BuildContext context,
    bool canCloseByBackButton = true,
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
                        const Text(
                          "New Post",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ValueListenableBuilder(
                          valueListenable: gotPost,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            Widget child = files.isNotEmpty && value
                                ? Image.file(
                                    files[0],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  )
                                : Container();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                child,
                                TextButton(
                                    onPressed: value
                                        ? () {}
                                        : () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        type: FileType.image,
                                                        allowMultiple: false);
                                            if (result != null) {
                                              files = result.paths
                                                  .map((path) => File(path!))
                                                  .toList();
                                              gotPost.value = true;
                                            }
                                          },
                                    style: TextButton.styleFrom(
                                        foregroundColor:
                                            value ? Colors.grey : Colors.blue),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.image),
                                        Text("  Choose Image"),
                                      ],
                                    )),
                              ],
                            );
                          },
                        ),
                        _getCaptionField,
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5))),
                                  ),
                                  onPressed: () {
                                    addPost();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Post",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5))),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    files.clear();
                                    gotPost.value = false;
                                    captionController.clear();
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ],
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

  addPost() {
    homeBloc.add(AddPostEvent(file: files[0], caption: captionController.text));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final post = Post.fromSnapshot(snapshot);

    return ReusableWidgets.postItem(
        context: context,
        userImage: post.profilePhoto,
        username: post.username,
        location: "Dehradun",
        likedUserImage: AssetStrings.userProfile1,
        likedUsername: "user4567",
        caption: post.caption,
        postURL: post.url);
  }
}
