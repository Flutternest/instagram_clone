import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/asset_strings.dart';

class ReusableWidgets {
  static Widget postItem(
      {required String userImage,
      required String username,
      required String? location,
      required String postURL,
      required String likedUserImage,
      required String likedUsername,
      required String caption,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 10),
            child: Row(
              children: [
                getProfileWidget(
                    userImage: userImage,
                    online: true,
                    radius: 10,
                    outerWidth: 1.5,
                    innerWidth: 1.5),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    location == null ? Container() : Text(location),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert_rounded)
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: postURL,
              progressIndicatorBuilder: (c, s, p) {
                return const CupertinoActivityIndicator();
              },
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 10),
            child: Row(
              children: const [
                Icon(Icons.favorite_border_rounded),
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.chat_bubble_outline_rounded),
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.send),
                Spacer(),
                Icon(Icons.bookmark_border_rounded),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 8,
                  backgroundImage: AssetImage(likedUserImage),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                    children: [
                      const TextSpan(
                          text: "Liked by ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          text: likedUsername,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: " and ", style: TextStyle(color: Colors.black)),
                      const TextSpan(
                          text: "others",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold))
                    ],
                  )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10),
            child: RichText(
                text: TextSpan(
              children: [
                TextSpan(
                    text: username,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500)),
                TextSpan(
                    text: " $caption",
                    style: const TextStyle(color: Colors.black))
              ],
            )),
          )
        ],
      ),
    );
  }

  static Widget storyItem({
    required String username,
    required String userImage,
    bool online = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            getProfileWidget(
                userImage: userImage,
                outerWidth: 2,
                innerWidth: 3,
                radius: 32,
                online: online),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(username, overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }

  static Widget getProfileWidget({
    required String userImage,
    required bool online,
    required double outerWidth,
    required double innerWidth,
    required double radius,
  }) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.pink, width: outerWidth)),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: innerWidth),
        ),
        child: online
            ? CircleAvatar(
                backgroundColor: Colors.white,
                radius: radius,
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(radius),
                    child: CachedNetworkImage(
                      imageUrl: userImage.isNotEmpty
                          ? userImage
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
                ))
            : CircleAvatar(
                backgroundImage: AssetImage(userImage),
                radius: radius,
              ),
      ),
    );
  }
}
