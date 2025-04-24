// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? userName;
  String? commentText;
  String? userProfileImage;
  String? userID;
  String? commentID;
  final publishedDateTime;
  List? commentLikesList;

  Comment({
    this.userName,
    this.commentText,
    this.userProfileImage,
    this.userID,
    this.commentID,
    this.publishedDateTime,
    this.commentLikesList,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "commentText": commentText,
        "userProfileImage": userProfileImage,
        "userID": userID,
        "commentID": commentID,
        "publishedDateTime": publishedDateTime,
        "commentLikesList": commentLikesList,
      };

  static Comment fromdDocumentSnapshot(DocumentSnapshot snapshotDoc) {
    /*
    DocumentSnapshot snapshotDoc parametresi, Firestore'dan alınan bir belgenin anlık görüntüsünü temsil eder 
    ve bu belgenin verilerine erişmek için kullanılır.
    */
    var documentSnapshot = snapshotDoc.data() as Map<String, dynamic>;
    return Comment(
      userName: documentSnapshot["userName"],
      commentText: documentSnapshot["commentText"],
      userProfileImage: documentSnapshot["userProfileImage"],
      userID: documentSnapshot["userID"],
      commentID: documentSnapshot["commentID"],
      publishedDateTime: documentSnapshot["publishedDateTime"],
      commentLikesList: documentSnapshot["commentLikesList"],
    );
  }
}
