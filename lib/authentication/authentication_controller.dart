// ignore_for_file: unused_local_variable, library_prefixes

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/authentication/login_screen.dart';
import 'package:tiktok_clone/authentication/registration_screen.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/home/home_screen.dart';
import 'user.dart' as userModel; //user.dart userModel gibi gösterildi

class AuthenticationController extends GetxController {
  static AuthenticationController instanceAuth = //örnek kimlik doğrulaması
      Get.find(); //instanceAuth registration sayfasından çağrıldı
  late Rx<User?> _currentUser;
  late Rx<File?> _pickedFile;
  File? get profileImage => _pickedFile.value;

  void chooseImageFromGallery() async {
    try {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImageFile != null) {
        Get.snackbar(
            'Profile Image', 'you have succesfully selected profile image ');
      }
      _pickedFile = Rx<File?>(File(pickedImageFile!.path));
      debugPrint('is empty : ${_pickedFile.value}');
    } catch (e) {
      debugPrint('pick gallery excption : $e');
    }
  }

  void captureImageWithCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImageFile != null) {
      Get.snackbar('Profile Image',
          'you have succesfully captured your profile image with phone camera');
    }
    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void createAccountForNewUser(File imageFile, String userName,
      String userEmail, String userPassword) async {
    try {
      //1. create user in the firebase authentication
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      //2. save the user profile image to firebase storage
      String imageDownloadUrl = await uploadImageToStorage(imageFile);

      //3. save user data to the firestore database

      userModel.User user = userModel.User(
        //import'ta userModel ile ilgili dönüşüm yapıldı
        name: userName,
        email: userEmail,
        image: imageDownloadUrl,
        uid: credential.user!.uid,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toJson());

      Get.snackbar(
          'Account Created', 'Congratulations,your account has been created');
      showProgressBar = false;
    } catch (error) {
      Get.snackbar('Account Creation Unsuccessful',
          'Error occurred while creating account. Try Again');
      showProgressBar = false;
      Get.to(const LoginScreen());
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Profile Images')
        .child(FirebaseAuth.instance.currentUser!
            .uid); //son eklenen uid storageta Profile Images altında
    //herbir uid'ye göre kayıt işlemi sağlanır

    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;

/*
UploadTask, yükleme işlemini temsil eder ve yüklemenin ilerlemesini takip etmek, iptal etmek veya durdurmak için kullanılabilirken, 
TaskSnapshot, yükleme işleminin sonucunu temsil eder ve yüklenen dosyanın sonuçlarını elde etmek için kullanılabilir.
*/

    String downloadUrlOfUploadedImage = await taskSnapshot.ref.getDownloadURL();

    return downloadUrlOfUploadedImage;
  }

  void loginUserNow(String userEmail, String userPassword) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      Get.snackbar('Logged-in Successful', 'you are logged-in successfully');
      showProgressBar = false;
    } catch (error) {
      Get.snackbar(
          'Login Unsuccessful', 'Error occurred during signin authentication');
      showProgressBar = false;
      Get.to(() => const RegistrationScreen());
    }
  }

  goToScreen(User? currentUser) {
    //when user is NOT already logged-in
    //when user click on signOut button
    if (currentUser == null) {
      Get.offAll(() => const LoginScreen());
      /*
      Get.offAll() metodu, tüm geçmişi temizleyerek , LoginScreen() sayfasına yönlendirir.
      Genel olarak, Get.offAll() komutu, uygulama başlangıcında kullanıcıyı giriş sayfasına 
      yönlendirmek veya oturumu kapatma işleminden sonra kullanıcıyı giriş sayfasına geri yönlendirmek gibi senaryolarda kullanılır. 
       */
    }
    //when user is already logged-in
    else {
      Get.offAll(() => const HomeScreen());
      //Get.off() metodu, Get.offAll() ile farklı olarak, geçmişteki diğer sayfaları kapatmaz
    }
  }

  @override
  void onReady() {
    super.onReady();
    _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    //Rx, GetX paketinin sağladığı reaktif programlama kütüphanesidir ve değişen bir değeri temsil eder.
    //Bu kod parçası, sayfanın hazır olduğunda mevcut kullanıcıyı alır ve _currentUser Rx nesnesine atar. Böylece,
    //kullanıcının giriş durumu değiştiğinde veya kullanıcı bilgileri güncellendiğinde _currentUser Rx nesnesi otomatik olarak
    //güncellenecek ve buna bağlı olan diğer işlevler veya arayüz bileşenleri güncellenecektir
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    //_currentUser.bindStream() metodu, _currentUser Rx nesnesini Firebase Authentication'in kimlik durumu değişikliklerini takip eden
    //Stream ile bağlar. Bu sayede, kullanıcının oturum açma durumu değiştiğinde veya oturumu kapattığında _currentUser Rx nesnesi
    //otomatik olarak güncellenir ve buna bağlı olan diğer işlevler veya arayüz bileşenleri güncellenir.
    ever(_currentUser, goToScreen);
    //_currentUser Rx nesnesinin değeri değiştiğinde goToScreen adlı bir işlevin çağrılmasını sağlar.
  }
}
