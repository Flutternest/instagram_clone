import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/home/home.dart';
import 'package:instagram_clone/features/others/activity.dart';
import 'package:instagram_clone/features/others/explore.dart';
import 'package:instagram_clone/features/others/reels.dart';
import 'package:instagram_clone/features/profile/profile.dart';
import 'package:instagram_clone/features/user_data.dart';
import 'package:instagram_clone/utils/asset_strings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  UserData userData = UserData();

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                MyHomePage(),
                ExploreScreen(),
                ReelsScreen(),
                ActivityScreen(),
                ProfileScreen()
              ]),
          bottomNavigationBar: SizedBox(
            height: 40,
            child: TabBar(
              labelPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              indicatorColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                currentIndex.value = index;
              },
              tabs: [
                _getTabItem(
                  icon: Icons.home,
                ),
                _getTabItem(
                  icon: Icons.search,
                ),
                _getTabItem(
                  icon: Icons.tiktok_rounded,
                ),
                _getTabItem(
                  icon: Icons.favorite_border_rounded,
                ),
                ValueListenableBuilder(
                  valueListenable: currentIndex,
                  builder: (BuildContext context, int value, Widget? child) {
                    return Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: value == 4
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2)),
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 13,
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(13),
                              child: CachedNetworkImage(
                                imageUrl: userData.profilePhoto.isNotEmpty
                                    ? userData.profilePhoto
                                    : AssetStrings.userImage,
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
                              ),
                            ),
                          )),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _getTabItem({required IconData icon}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Icon(
          icon,
          size: 30,
        ));
  }
}
