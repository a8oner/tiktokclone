// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/home/comments/comments_screen.dart';
import 'package:tiktok_clone/home/following/controller_following_videos.dart';
import 'package:tiktok_clone/widgets_components/circular_image_animation.dart';
import 'package:tiktok_clone/widgets_components/custom_video_player.dart';

class FollowingsVideoScreen extends StatefulWidget {
  const FollowingsVideoScreen({super.key});

  @override
  State<FollowingsVideoScreen> createState() => _FollowingsVideoScreenState();
}

class _FollowingsVideoScreenState extends State<FollowingsVideoScreen> {
  final ControllerFollowingVideos controllerFollowingVideos =
      Get.put(ControllerFollowingVideos());
  /*
      Bu şekilde yapılan kayıt işlemi sayesinde, controllerFollowingVideos nesnesi uygulama içinde 
      herhangi bir noktadan erişilebilir hale gelir. Bu sınıfın örneği başka sınıflar tarafından bağımlılık olarak kullanılabilir veya 
      widget ağacının farklı yerlerinde kullanılabilir.
   Örneğin, bu nesne bir sayfa veya widget tarafından kullanılmak istendiğinde, Get.find() yöntemi kullanılarak bu nesneye erişilebilir.
    Örneğin:final controller = Get.find<ControllerForYouVideos>();
      */
  /*
 Get.put() yöntemi: Bu yöntem, bir sınıf örneğini GetX bağımlılık yöneticisine kaydeder. Yani, bir sınıfın örneğini başka bir yerde 
 kullanmak istediğinizde, bu yöntemi kullanarak örneği kaydedebilirsiniz. Kaydedilen sınıf örneği, uygulama boyunca erişilebilir hale 
 gelir ve diğer yerlerden Get.find() ile erişilebilir. Bu yöntem genellikle sınıfın ilk kez oluşturulduğu yerde kullanılır.
Get.find() yöntemi: Bu yöntem, GetX bağımlılık yöneticisinde kaydedilen bir sınıfın örneğine erişmek için kullanılır. Kaydedilen sınıf
 örneğini başka bir yerde kullanmak veya erişmek istediğinizde bu yöntemi kullanarak örneğe erişebilirsiniz. Yani, Get.find() yöntemiyle
  kaydedilen bir sınıfın örneğini başka bir sınıfta veya widget'ta elde edebilir ve örneğin fonksiyonlarına veya durumlarına erişebilirsiniz.
 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
            itemCount: controllerFollowingVideos.followingAllVideosList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final eachVideoInfo =
                  controllerFollowingVideos.followingAllVideosList[index];
              return Stack(
                children: [
                  //video
                  CustomVideoPlayer(
                    videoFileUrl: eachVideoInfo.videoUrl.toString(),
                  ),
                  //left-right panels
                  Column(
                    children: [
                      const SizedBox(
                        height: 110,
                      ),
                      //left-right paneks
                      Expanded(
                          child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //left panel
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.only(left: 18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //username
                                Text(
                                  "@" + eachVideoInfo.userName.toString(),
                                  style: GoogleFonts.abel(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                //description - tags
                                Text(
                                  eachVideoInfo.descriptionTags.toString(),
                                  style: GoogleFonts.abel(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                //artist - song name
                                Row(
                                  children: [
                                    Image.asset(
                                      "images/music_note.png",
                                      width: 20,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "   " +
                                            eachVideoInfo.artistSongName
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.alexBrush(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                          //right panel
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //profile
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: 62,
                                    height: 62,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            left: 4,
                                            child: Container(
                                              width: 52,
                                              height: 52,
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Image(
                                                  image: NetworkImage(
                                                    eachVideoInfo
                                                        .userProfileImage
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                //like button - total Likes
                                Column(
                                  children: [
                                    //like button
                                    IconButton(
                                      onPressed: () {
                                        controllerFollowingVideos
                                            .likeOrUnlikeVideo(eachVideoInfo
                                                .videoID
                                                .toString());
                                      },
                                      icon: Icon(
                                        Icons.favorite_rounded,
                                        size: 40,
                                        color: eachVideoInfo.likesList!
                                                .contains(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                    //total likes
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        eachVideoInfo.likesList!.length
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                //comment button - total comments
                                Column(
                                  children: [
                                    //comment button
                                    IconButton(
                                      onPressed: () {
                                        Get.to(CommentsScreen(
                                          videoID:
                                              eachVideoInfo.videoID.toString(),
                                        ));
                                      },
                                      icon: const Icon(
                                        Icons.add_comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    //total comments
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        eachVideoInfo.totalComments.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                //share button - total shares
                                Column(
                                  children: [
                                    //share button
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    //total shares
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        eachVideoInfo.totalShares.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                //profile circular animation
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircularImageAnimation(
                                    widgetAnimation: SizedBox(
                                      width: 62,
                                      height: 62,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            height: 52,
                                            width: 52,
                                            decoration: BoxDecoration(
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Colors.grey,
                                                Colors.white,
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image(
                                                image: NetworkImage(
                                                  eachVideoInfo.userProfileImage
                                                      .toString(),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              );
            });
      }),
    );
  }
}
