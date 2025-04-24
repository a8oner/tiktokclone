// ignore_for_file: avoid_unnecessary_containers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/home/upload_video/upload_controller.dart';
import 'package:video_player/video_player.dart';

import '../../widgets_components/input_text_widget.dart';

class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const UploadForm(
      {super.key, required this.videoFile, required this.videoPath});

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  UploadController uploadVideoController = Get.put(UploadController());
  VideoPlayerController? playerController;
  TextEditingController artistSongTextEditingController =
      TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    playerController!
        .initialize(); // VideoPlayerController nesnesinin başlatılmasını sağlar. Bu yöntem, videoyu yüklemek ve hazır hale getirmek için kullanılır.
    playerController!
        .play(); //Oynatma işlemini başlatır. Bu yöntem, videoyu oynatmaya başlar.
    playerController!.setVolume(2);
    playerController!.setLooping(
        false); // Videoyu döngüsel olarak oynatmayı ayarlar. Eğer bu değer true olarak ayarlanırsa, video oynatıldıktan sonra sona erdiğinde tekrar başa döner ve sürekli olarak döngü içinde oynatılır.
  }

  @override
  void dispose() {
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //video_player peketi eklendi
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //display video player
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.3,
              child: VideoPlayer(playerController!),
            ),
          const  SizedBox(
              height: 30,
            ),
            //Upload Now
            //circular progress bar
            //input fields
            showProgressBar == true
                ? Container(
                    child: const SimpleCircularProgressBar(
                      progressColors: [
                        Colors.green,
                        Colors.blueAccent,
                        Colors.red,
                        Colors.amber,
                        Colors.purpleAccent,
                      ],
                      animationDuration: 20,
                      backColor: Colors.white38,
                    ),
                  )
                : Column(
                    children: [
                      //artist-song

                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                            textEditingController:
                                artistSongTextEditingController,
                            lableString: 'Artist-Song',
                            iconData: Icons.music_video_sharp,
                            isObscure: false),
                      ),
                 const     SizedBox(
                        height: 10,
                      ),
                      //description tags

                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextWidget(
                            textEditingController:
                                descriptionTextEditingController,
                            lableString: 'Description-Tags',
                            iconData: Icons.slideshow_sharp,
                            isObscure: false),
                      ),
                 const     SizedBox(
                        height: 10,
                      ),
                      //upload now button
                      Container(
                        width: MediaQuery.of(context).size.width - 38,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (artistSongTextEditingController
                                    .text.isNotEmpty &&
                                descriptionTextEditingController
                                    .text.isNotEmpty) {
                              uploadVideoController
                                  .saveVideoInformationToFirestoreDatabase(
                                      artistSongTextEditingController.text,
                                      descriptionTextEditingController.text,
                                      widget.videoPath,
                                      context);
                              setState(() {
                                showProgressBar = true;
                              }); 
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Upload Now',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                  const    SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
