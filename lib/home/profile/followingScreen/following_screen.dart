import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/home/profile/profile_controller.dart';

import '../profile_screen.dart';

class FollowingScreen extends StatefulWidget {
  String visitedProfileUserID;
  FollowingScreen({
    required this.visitedProfileUserID,
  });

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<String> followingKeysList = [];
  List followingUsersDataList = [];
  ProfileController controllerProfile = Get.put(ProfileController());

  getFollowingListKeys() async {
    var followingDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.visitedProfileUserID)
        .collection("following")
        .get();
    for (int i = 0; i < followingDocument.docs.length; i++) {
      followingKeysList.add(followingDocument.docs[i].id);
    }
    getFollowingKeysDataFromUsersCollection(followingKeysList);
  }

  getFollowingKeysDataFromUsersCollection(
      List<String> listOfFollowingKeys) async {
    var allUsersDocument =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int j = 0; j < listOfFollowingKeys.length; j++) {
        if (((allUsersDocument.docs[i].data() as dynamic)["uid"]) ==
            listOfFollowingKeys[j]) {
          followingUsersDataList.add((allUsersDocument.docs[i].data()));
        }
      }
    }
    setState(() {
      followingUsersDataList;
    });
  }

  @override
  void initState() {
    super.initState();

    getFollowingListKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              controllerProfile.userMap["userName"],
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "Following" + controllerProfile.userMap["totalFollowings"],
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: followingUsersDataList.isEmpty
          ? const Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.white,
                size: 60,
              ),
            )
          : ListView.builder(
              itemCount: followingUsersDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Get.to(ProfileScreen(
                          visitUserID: followingUsersDataList[index]["uid"],
                        ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              followingUsersDataList[index]["image"]
                                  .toString()),
                        ),
                        title: Text(
                          followingUsersDataList[index]["name"].toString(),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        subtitle: Text(
                          followingUsersDataList[index]["email"].toString(),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Get.to(ProfileScreen(
                                visitUserID: followingUsersDataList[index]
                                    ["uid"],
                              ));
                            },
                            icon: const Icon(
                              Icons.navigate_next_outlined,
                              size: 24,
                              color: Colors.redAccent,
                            )),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
