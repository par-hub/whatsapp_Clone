import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/features/auth/repository/repository.dart';
import 'package:whatsapp/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final repository =
      AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
  return AuthController(repository, ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final Ref ref;
  final AuthRepository _repository;

  AuthController(this._repository, this.ref);

  Future<UserModel?> getUserData() async {
    UserModel? user = await _repository.getCurrentUserData();
    return user;
  }

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    _repository.SignUpWithEmail(
      email: email,
      password: password,
      context: context,
    );
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    _repository.signInWithEmail(
      email: email,
      password: password,
      context: context,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic, String phoneNumber) {
    _repository.saveUserDataToFirebase(
        name: name,
        profilePic: profilePic,
        ref: ref,
        context: context,
        phoneNumber: phoneNumber);
  }

  Stream<UserModel> userDataById(String userId) {
    return _repository.userData(userId);
  }

  void setUserState(bool isOnline) async {
    return _repository.setUserState(isOnline);
  }
}
