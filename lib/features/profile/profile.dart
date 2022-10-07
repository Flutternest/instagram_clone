import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/login/login.dart';
import 'package:instagram_clone/features/user_data.dart';
import 'package:instagram_clone/utils/app_messages.dart';
import 'package:instagram_clone/utils/asset_strings.dart';
import 'package:instagram_clone/utils/reusable_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  UserData userData = UserData();

  List items = [
    AssetStrings.userProfile1,
    AssetStrings.userProfile2,
    AssetStrings.userProfile3,
    AssetStrings.userProfile4,
    AssetStrings.userProfile5,
    AssetStrings.userProfile6,
    AssetStrings.userProfile7,
    AssetStrings.userProfile8,
    AssetStrings.userProfile9,
    AssetStrings.userProfile10,
    AssetStrings.userProfile11,
    AssetStrings.userProfile12,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.lock_outline_rounded,
                color: Colors.black,
                size: 17,
              ),
            ),
            Text(
              userData.username,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 22,
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              signOutDialog(
                  context: context,
                  title: AppMessages.signOutTitle,
                  message: AppMessages.signOutBody,
                  onPressed: () {
                    signOut();
                    Navigator.pop(context);
                  });
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableWidgets.getProfileWidget(
                    userImage: userData.profilePhoto,
                    online: true,
                    radius: 35,
                    outerWidth: 2.5,
                    innerWidth: 2),
                getStatsColumn(number: "7", label: "Posts"),
                getStatsColumn(number: "245", label: "Followers"),
                getStatsColumn(number: "4586", label: "Following"),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 3.0, left: 10),
            child: Text(
              "Name Of The User",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(userData.bio),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.07,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("Edit Profile")),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      "Story Highlights",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_up_rounded),
                  ],
                ),
                const Text("Keep your favourite stories on your profile"),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHighlightWidget(
                      circleColor: Colors.transparent,
                      borderColor: Colors.black,
                      iconColor: Colors.black,
                      borderWidth: 1,
                      highlightText: "New"),
                  getHighlightWidget(
                      circleColor: Colors.grey[300],
                      borderColor: Colors.transparent,
                      iconColor: Colors.transparent,
                      borderWidth: 0,
                      highlightText: ""),
                  getHighlightWidget(
                      circleColor: Colors.grey[300],
                      borderColor: Colors.transparent,
                      iconColor: Colors.transparent,
                      borderWidth: 0,
                      highlightText: ""),
                  getHighlightWidget(
                      circleColor: Colors.grey[300],
                      borderColor: Colors.transparent,
                      iconColor: Colors.transparent,
                      borderWidth: 0,
                      highlightText: ""),
                  getHighlightWidget(
                      circleColor: Colors.grey[300],
                      borderColor: Colors.transparent,
                      iconColor: Colors.transparent,
                      borderWidth: 0,
                      highlightText: ""),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: TabBar(
              indicatorColor: Colors.black,
              controller: tabController,
              tabs: const [
                Tab(
                  icon: Icon(
                    Icons.grid_on_sharp,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.people_alt_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: TabBarView(
              controller: tabController,
              children: [
                GridView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return getPostBox(postURL: items[index]);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3),
                ),
                GridView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return getPostBox(postURL: items[index + 5]);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return LoginScreen();
    }), (route) => false);
  }

  //Method to show custom alert box
  signOutDialog({
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
                                  onPressed: onPressed,
                                  child: const Text(
                                    "Yes",
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

  Widget getPostBox({required String postURL}) {
    return Container(
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(postURL), fit: BoxFit.cover)),
    );
  }

  Widget getHighlightWidget({
    required Color? circleColor,
    required Color borderColor,
    required Color iconColor,
    required double borderWidth,
    required String highlightText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
                border: Border.all(width: borderWidth, color: borderColor)),
            child: Center(
              child: Icon(Icons.add, color: iconColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(highlightText),
          ),
        ],
      ),
    );
  }

  Widget getStatsColumn({
    required String number,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
        )
      ],
    );
  }
}
