import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/features/user_data.dart';
import 'package:marquee/marquee.dart';

import '../../utils/asset_strings.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  PageController reelController = PageController();
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> needInfo = ValueNotifier(true);
  ValueNotifier<bool> following = ValueNotifier(false);
  ValueNotifier<bool> showCaption = ValueNotifier(false);
  ValueNotifier<bool> scrollingBackwards = ValueNotifier(false);
  UserData userData = UserData();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: reelController,
      scrollDirection: Axis.vertical,
      onPageChanged: (int index) {
        currentIndex.value = index;
        scrollingBackwards.value = index < (reelController.page ?? 0);
        if (kDebugMode) {
          print(scrollingBackwards);
        }
      },
      itemBuilder: (context, index) {
        currentIndex.value = index;
        return getReelItem(url: Constants.forBiggerBlazesUrl, index: index);
      },
    );
  }

  Widget getReelItem({required String url, required int index}) {
    return Stack(
      children: [
        BetterPlayer.network(
          url,
          betterPlayerConfiguration: BetterPlayerConfiguration(
              autoDispose: false,
              autoPlay: false,
              // autoPlay: currentIndex.value == index ? true : false,
              looping: true,
              deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              controlsConfiguration:
                  const BetterPlayerControlsConfiguration(showControls: false)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                getActionIconButtons(
                    icon: Icons.favorite_border_rounded, number: "21.6k"),
                getActionIconButtons(
                    icon: Icons.chat_bubble_outline_rounded, number: "216"),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 15,
                ),
                getAudioBox(),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 13,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(15),
                          child: CachedNetworkImage(
                            imageUrl: userData.profilePhoto.isNotEmpty
                                ? userData.profilePhoto
                                : AssetStrings.userImage,
                            fit: BoxFit.fitWidth,
                            progressIndicatorBuilder: (context, str, progress) {
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
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    userData.username,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  following.value
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 5),
                            child: Text("Follow"),
                          )),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: showCaption,
                builder: (context, value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 12),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 200, minHeight: 10),
                      child: SingleChildScrollView(
                        child: InkWell(
                          onTap: () {
                            showCaption.value = !(showCaption.value);
                            if (kDebugMode) {
                              print("TAPPED ${showCaption.value}");
                            }
                          },
                          child: value
                              ? const Text(
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?"
                                  "This is the caption, hello, hi, what do you think of this video? This is the caption, hello, hi, what do you think of this video?",
                                  style: TextStyle(color: Colors.white),
                                )
                              : const Text(
                                  "This is the caption, hello, hi, what do you think of this video?",
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.queue_music,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  needInfo.value
                      ? Expanded(
                          child: SizedBox(
                            height: 20,
                            width: 35,
                            child: Marquee(
                              blankSpace: 15,
                              text:
                                  'username_of_the_creator  •  Original audio',
                              style: const TextStyle(color: Colors.white),
                              velocity: 25.0,
                            ),
                          ),
                        )
                      : const Text(
                          "username_of_the_creator  •  Original audio",
                          style: TextStyle(color: Colors.white),
                        ),
                  const SizedBox(
                    width: 5,
                  ),
                  needInfo.value
                      ? Expanded(
                          child: getInfoLabels(
                              type: 3, label: "AU NATURE AUTUMN EFFECT"),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        index == 0 || scrollingBackwards.value
            ? const Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Reels",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            : Container(),
        const Padding(
          padding: EdgeInsets.only(right: 15, top: 10),
          child: Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget getInfoLabels({
    required int type,
    required String label,
  }) {
    IconData iconData;
    switch (type) {
      case 1:
      case 2:
        iconData = Icons.person_outline_outlined;
        break;
      case 3:
        iconData = Icons.auto_awesome;
        break;
      case 4:
        iconData = Icons.location_on_rounded;
        break;
      default:
        iconData = Icons.abc_rounded;
    }
    return Row(
      children: [
        Icon(
          iconData,
          color: Colors.white,
          size: 15,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget getActionIconButtons({
    required IconData icon,
    required String number,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          InkWell(
              onTap: () {},
              child: Icon(
                icon,
                color: Colors.white,
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            number,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget getAudioBox() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white, width: 1.5),
          color: Colors.white),
      child: ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(12),
          child: CachedNetworkImage(
            imageUrl: userData.profilePhoto.isNotEmpty
                ? userData.profilePhoto
                : AssetStrings.userImage,
            fit: BoxFit.fitWidth,
            progressIndicatorBuilder: (context, str, progress) {
              return const CupertinoActivityIndicator();
            },
            errorWidget: (context, str, _) {
              return const Center(
                child: Icon(Icons.person),
              );
            },
          ),
        ),
      ),
    );
  }
}
