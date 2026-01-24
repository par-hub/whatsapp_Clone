import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/screens/user_information.dart';
import 'package:whatsapp/common/repositories/commom_firbase_storage_repository.dart';
import 'package:whatsapp/common/utils/util.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp/screens/mobilescreen_layout.dart';

class AuthRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth _auth;
  AuthRepository(this._auth, this.firestore);

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection("users").doc(_auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<void> SignUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacementNamed(context, UserInformationScreen.routeName);
    } on FirebaseAuthException catch (e) {
      _showError(context, e.message);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, MobilescreenLayout.routeName);
    } on FirebaseAuthException catch (e) {
      _showError(context, e.message);
    }
  }

  void _showError(BuildContext context, String? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'An error occurred')),
    );
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required String phoneNumber,
      required Ref ref,
      required BuildContext context}) async {
    try {
      String uid = _auth.currentUser!.uid;
      String photoUrl =
          "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png";

      if (profilePic != null) {
        photoUrl = await ref
            .read(CommomFirbaseStorageRepositoryProvider)
            .storeFileToFirebase("profilepic/$uid", profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          groupId: [],
          phoneNumber: phoneNumber);
      await firestore.collection("users").doc(uid).set(user.toMap());

      Navigator.pushReplacementNamed(context, MobilescreenLayout.routeName);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
