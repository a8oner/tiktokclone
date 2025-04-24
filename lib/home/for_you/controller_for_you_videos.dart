import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../upload_video/video.dart';

class ControllerForYouVideos extends GetxController {
  final Rx<List<Video>> forYouVideosList = Rx<List<Video>>([]);
  //Rx nesnesi, bir akış (stream) olduğunu belirtir.veri geldikçe güncellenir
  List<Video> get forYouAllVideosList => forYouVideosList.value;

  @override
  void onInit() {
    super.onInit();
    forYouVideosList.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .orderBy("totalComments",
            descending:
                true) //descending : çok beğeniden aza doğru sıralamayı göstermek için onay,parametre: totalComments
        .snapshots()
        .map((QuerySnapshot
                snapshotQuery) //snapQuery:1-2-3...video bilgileri(databaseden) almak için
            {
      List<Video> videoList = [];

      for (var eachVideo in snapshotQuery.docs) {
        videoList.add(Video.fromDocumentSnapshot(eachVideo));
      }
      return videoList;
    }));
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
