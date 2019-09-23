import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProviderModel extends ChangeNotifier {
  Map userData;
  FirebaseUser userFirebase;

  String getUserSkills() {
    return userData['skills']
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
  }

  dynamic getCurriculumUser(String curriculumName) async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child(userFirebase.uid + "/$curriculumName");

    dynamic url;

    try {
      url = await reference.getDownloadURL();
    } catch (e) {}

    return url;
  }
}
