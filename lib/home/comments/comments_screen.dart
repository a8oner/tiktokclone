// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, library_prefixes, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'comments_controller.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentsScreen extends StatelessWidget {
  final String videoID;
  CommentsScreen({required this.videoID});

  TextEditingController commentTextEditingController = TextEditingController();
  CommentsController commentsController = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    commentsController.updateCurrentVideoID(videoID);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              //display comments
              Expanded(child: Obx(() {
                return ListView.builder(
                    itemCount: commentsController.listOfComments.length,
                    itemBuilder: (context, index) {
                      final eachCommentInfo =
                          commentsController.listOfComments[index];
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage: NetworkImage(eachCommentInfo
                                    .userProfileImage
                                    .toString()),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eachCommentInfo.userName.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    eachCommentInfo.commentText.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  //timeage kullanıcıya kesin zaman yerine, bir olayın ne kadar süre önce veya sonra gerçekleştiğini göstermek için tercih edilen bir yaklaşımdır.
                                  Text(
                                    tAgo.format(eachCommentInfo
                                        .publishedDateTime
                                        .toDate()),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                              const    SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    eachCommentInfo.commentLikesList!.length
                                            .toString() +
                                        "likes",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    commentsController.likeUnlikeComment(
                                        eachCommentInfo.commentID.toString());
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: eachCommentInfo.commentLikesList!
                                            .contains(FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? Colors.red
                                        : Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      );
                    });
              })),
              //add new comment box
              Container(
                color: Colors.white24,
                child: ListTile(
                  title: TextFormField(
                    controller: commentTextEditingController,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Add a Comment Here",
                      labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        if (commentTextEditingController.text.isNotEmpty) {
                          commentsController.saveNewCommentToDatabase(
                              commentTextEditingController.text);
                          commentTextEditingController.clear();
                        }
                      },
                      icon:const Icon(
                        Icons.send,
                        size: 40,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
