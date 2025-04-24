// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'comment.dart';

class CommentsController extends GetxController {
  String currentVideoID = "";
  final Rx<List<Comment>> commentsList = Rx<List<Comment>>([]);
  List<Comment> get listOfComments => commentsList.value;
/*
Rx nesnesi, değerlerin dinamik olarak güncellenmesine izin verir ve veri akışını takip edebilirsiniz.
 Örneğin, commentsList nesnesi güncellendiğinde (yani listenin içeriği değiştiğinde), bu güncellemeleri takip eden kodu tetikleyebilir 
 ve buna yanıt olarak farklı işlemler gerçekleştirebilirsiniz.
*/

  updateCurrentVideoID(String videoID) {
    currentVideoID = videoID;
    retrieveComments();
  }

  saveNewCommentToDatabase(String commentTextData) async {
    try {
      String commentID = DateTime.now().millisecondsSinceEpoch.toString();
      DocumentSnapshot snapshotUserDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Comment commentModel = Comment(
        /*
        dynamic tipi, çalışma zamanında doğru tipe dönüştürüleceği için derleme zamanında hata almazsınız.
       Bu yaklaşım, belirli bir tipin yerine geçici olarak dynamic tipini kullanmanızı sağlar, 
       ancak tip güvenliğini kısmen kaybetmenize yol açar. Eğer doğru tipte bir veri bekliyorsanız, as dynamic ifadesi yerine as Map<String, dynamic> gibi belirli bir tip belirterek daha güvenli bir dönüşüm yapmanız önerilir.
        */
        userName: (snapshotUserDocument.data() as dynamic)["name"],
        userID: FirebaseAuth.instance.currentUser!.uid,
        userProfileImage: (snapshotUserDocument.data() as dynamic)["image"],
        commentText: commentTextData,
        commentID: commentID,
        commentLikesList: [],
        publishedDateTime: DateTime.now(),
      );

      //save new comment info to database
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoID)
          .collection("comments")
          .doc(commentID)
          .set(commentModel.toJson());

      //update comments counter
      DocumentSnapshot currentVideoSnapshotDocument = await FirebaseFirestore
          .instance
          .collection("videos")
          .doc(currentVideoID)
          .get();

      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoID)
          .update({
        "totalComments":
            (currentVideoSnapshotDocument.data() as dynamic)["totalComments"] +
                1,
      });
    } catch (errorMsg) {
      Get.snackbar(
          "Error in Posting New Comment", "Message: " + errorMsg.toString());
    }
  }

  retrieveComments() async {
    //geri almak, kurtarmak, kavuşmak
    commentsList.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .doc(currentVideoID)
        .collection("comments")
        .orderBy("publishedDateTime", descending: true) //descending:azalan
        .snapshots()
        .map((QuerySnapshot commentsSnapshot) {
      List<Comment> commentsListOfVideo = [];
      for (var eachComment in commentsSnapshot.docs) {
        commentsListOfVideo.add(Comment.fromdDocumentSnapshot(eachComment));
      }
      return commentsListOfVideo;
    }));
    /*
        Bu Flutter kodunda orderBy komutu, Firestore veritabanında comments koleksiyonunda yer alan belgeleri "publishedDateTime" 
        alanına göre sıralamak için kullanılıyor. descending: true parametresi, belgelerin "publishedDateTime" alanına göre azalan 
        sırada sıralanacağını belirtiyor. Yani, en yeni tarihten en eskiye doğru sıralama yapılacak.
        */
  }

  likeUnlikeComment(String commentID) async {
    DocumentSnapshot commentDocumentSnapshot = await FirebaseFirestore.instance
        .collection("videos")
        .doc(currentVideoID)
        .collection("comments")
        .doc(commentID)
        .get();
    //unlike comment feature - red heart button
    if ((commentDocumentSnapshot.data() as dynamic)["commentLikesList"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoID)
          .collection("comments")
          .doc(commentID)
          .update({
        "commentLikesList":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
    }
    //like comment feature white heart button
    else {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoID)
          .collection("comments")
          .doc(commentID)
          .update({
        "commentLikesList": FieldValue.arrayUnion([
          FirebaseAuth.instance.currentUser!.uid
        ]), //execute:uygulamak feature:özellik
      });
    }
  }
}
