import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repositories/commom_firbase_storage_repository.dart';
import 'package:whatsapp/common/utils/util.dart';
import 'package:whatsapp/models/call.dart';
import 'package:whatsapp/models/group.dart' as model;

final callRepositoryProvider = Provider((ref) => CallRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class CallRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  CallRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<DocumentSnapshot> callStream() {
    return firestore.collection('calls').doc(auth.currentUser!.uid).snapshots();
  }

  void makeCall(
      Call senderCallData, BuildContext context, Call receiverCallData) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('calls')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(String callerId, String receiverId) async {
    try {
      await firestore.collection('calls').doc(callerId).delete();
      await firestore.collection('calls').doc(receiverId).delete();
    } catch (e) {
      // Handle error if needed
    }
  }

  void saveCallHistory(Call call) async {
    try {
      await firestore
          .collection('call_history')
          .doc(call.callId)
          .set(call.toMap());
    } catch (e) {
      // Handle error if needed
    }
  }

  Stream<QuerySnapshot> getCallHistory() {
    return firestore
        .collection('call_history')
        .where('callerId', isEqualTo: auth.currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
