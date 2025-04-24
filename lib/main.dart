import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/authentication/authentication_controller.dart';
import 'package:tiktok_clone/authentication/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(
        AuthenticationController()); //Getput komutu bi nevi sayfalara içindekini tanıttırır
        // Get.put() komutu, GetX paketi aracılığıyla Flutter uygulamalarında bağımlılıkları yönetmek ve verileri paylaşmak için kullanılır.
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TikTok Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const LoginScreen(),
    );
  }
}
