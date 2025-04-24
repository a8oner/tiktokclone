  import 'package:firebase_auth/firebase_auth.dart';

bool showProgressBar = false;
String currentUserID=FirebaseAuth.instance.currentUser!.uid.toString();
