import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';

import '../upload_video/video.dart';

class ControllerFollowingVideos extends GetxController {
  final Rx<List<Video>> followingVideosList = Rx<List<Video>>([]);
  //Rx nesnesi, bir akış (stream) olduğunu belirtir.veri geldikçe güncellenir
  List<Video> get followingAllVideosList => followingVideosList.value;

  List<String> followingKeysList = [];

  @override
  void onInit() {
    super.onInit();
    getFollowingUsersVideos();
  }

  getFollowingUsersVideos() async {
    try {
      //1.get that followers
      var followingDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("following")
          .get();
      for (int i = 0; i < followingDocument.docs.length; i++) {
        followingKeysList.add(followingDocument.docs[i].id);
      }
      //2.get videos of that following people
      followingVideosList.bindStream(FirebaseFirestore.instance
          .collection("videos")
          .orderBy("publishedDateTime", descending: true)
          .snapshots()
          .map((QuerySnapshot snapshotVideos) {
        List<Video> followingPersonsVideos = [];
        for (var eachVideo in snapshotVideos.docs) {
          for (int i = 0; i < followingKeysList.length; i++) {
            String followingPersonID = followingKeysList[i];
            //      debugPrint( 'each video === ${Video.fromDocumentSnapshot(eachVideo)} , $followingKeysList');
            if (eachVideo["userID"] == followingPersonID) {
              followingPersonsVideos.add(Video.fromDocumentSnapshot(eachVideo));
            }
          }
        }
        return followingPersonsVideos;
      }));
    } catch (e) {
      debugPrint('getFollowingUsersVideos exception $e');
    }
  }

  likeOrUnlikeVideo(String videoID) async {
    var currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();
    DocumentSnapshot snapshotDoc = await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoID)
        .get();

    //if already Liked
    if ((snapshotDoc.data() as dynamic)["likesList"].contains(currentUserID)) {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoID)
          .update({
        "likesList": FieldValue.arrayRemove([currentUserID]),
      });
    }
    //if NOT-Liked
    else {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoID)
          .update({
        "likesList": FieldValue.arrayUnion([currentUserID]),
      });
    }
  }
}
