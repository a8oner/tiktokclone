// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_clone/authentication/authentication_controller.dart';
import 'package:tiktok_clone/authentication/login_screen.dart';

import '../global.dart';
import '../widgets_components/input_text_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Create Account",
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "to get Started Now",
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              //profile avatar
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      //ios kısmına eklenti var . video 12 add permission for using...
                      onTap: () {
                        authenticationController.chooseImageFromGallery();
                      },
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            AssetImage('images/profile_avatar.jpg'),
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //user name input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: userNameTextEditingController,
                    lableString: 'Username',
                    iconData: Icons.person_outline,
                    isObscure: false),
              ),
              const SizedBox(
                height: 25,
              ),
              //email input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: emailTextEditingController,
                  lableString: 'Email',
                  iconData: Icons.email_outlined,
                  isObscure: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                /* 
                         TextFormField(
                  controller: emailTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email_outlined),
                  ),
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                */
              ),
              const SizedBox(
                height: 25,
              ),
              //password input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: passwordTextEditingController,
                    lableString: 'Password',
                    iconData: Icons.lock_outline,
                    isObscure: true),
              ),
              const SizedBox(
                height: 30,
              ),
              //login button
              //not have an account, signup now button
              showProgressBar == false
                  ? Column(
                      children: [
                        //signup button
                        Container(
                          width: MediaQuery.of(context).size.width - 38,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              try {
                                if (authenticationController
                                            .profileImage !=
                                        null &&
                                    userNameTextEditingController
                                        .text.isNotEmpty &&
                                    emailTextEditingController
                                        .text.isNotEmpty &&
                                    passwordTextEditingController
                                        .text.isNotEmpty) {
                                  setState(() {
                                    showProgressBar = true;
                                  });
                                  //create a new account for user
                                  authenticationController
                                      .createAccountForNewUser(
                                    authenticationController.profileImage!,
                                    userNameTextEditingController.text,
                                    emailTextEditingController.text,
                                    passwordTextEditingController.text,
                                  );
                                }
                                //  else {
                                //   debugPrint(' boşşşşş');
                                // }
                              } catch (e) {
                                debugPrint('button ontap excep : $e');
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => LoginScreen());
                              },
                              child: const Text(
                                'Login Now',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      child: const SimpleCircularProgressBar(
                        progressColors: [
                          Colors.red,
                          Colors.white,
                          Colors.yellow,
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
