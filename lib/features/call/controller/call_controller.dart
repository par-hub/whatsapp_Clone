// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/features/auth/controller/controller.dart';
import 'package:whatsapp/features/call/reository/call_repository.dart';

import 'package:whatsapp/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.watch(callRepositoryProvider);
  return CallController(
      callRepository: callRepository, ref: ref, auth: FirebaseAuth.instance);
});

class CallController {
  final CallRepository callRepository;
  final Ref ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> callStream() {
    return callRepository.callStream();
  }

  Future<Call?> makeCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
    String receiverProfilePic,
    bool isGroupChat,
  ) async {
    Call? call;
    await ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
        timestamp: DateTime.now(),
      );
      Call receiverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
        timestamp: DateTime.now(),
      );
      callRepository.makeCall(senderCallData, context, receiverCallData);
      callRepository.saveCallHistory(senderCallData);
      call = senderCallData;
    });
    return call;
  }

  void endCall(String callerId, String receiverId) {
    callRepository.endCall(callerId, receiverId);
  }
}
