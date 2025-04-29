// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_clone/authentication/registration_screen.dart';
import 'package:tiktok_clone/widgets_components/input_text_widget.dart';

import 'authentication_controller.dart';
//login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;
  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'images/tiktok.png',
                width: 200,
              ),
              Text(
                "Welcome",
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Glad to see you!",
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 30,
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
              ),
              const SizedBox(
                height: 25,
              ),
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
              showProgressBar == false
                  ? Column(
                      children: [
                        //login button
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
                              //login user now
                              if (emailTextEditingController.text.isNotEmpty &&
                                  passwordTextEditingController
                                      .text.isNotEmpty) {
                                setState(() {
                                  showProgressBar = true;
                                });
                                authenticationController.loginUserNow(
                                  emailTextEditingController.text,
                                  passwordTextEditingController.text,
                                );
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Login',
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
                              'Dont have an Account ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const RegistrationScreen());
                              },
                              child: const Text(
                                'SignUp Now',
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
