import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/authentication/user.dart';

class SearchController1 extends GetxController {
  final Rx<List<User>> _usersSearchedList = Rx<List<User>>([]);
  List<User> get usersSearchedList => _usersSearchedList.value;
 
  searchForUser(String textInput) async {
    _usersSearchedList.bindStream(FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: textInput)
        .snapshots()
        .map((QuerySnapshot searchedUsersQuerySnapshot) {
      List<User> searchList = [];
      for (var user in searchedUsersQuerySnapshot.docs) {
        searchList.add(User.fromSnap(user));
      }
      return searchList;
    }
    ));
  }
}
