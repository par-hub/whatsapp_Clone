// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final List<String> groupId;
  final String phoneNumber;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.groupId,
    required this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      uid: json['uid'] as String,
      profilePic: json['profilePic'] as String,
      isOnline: json['isOnline'] as bool,
      groupId: List<String>.from(json['groupId']),
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'groupId': groupId,
      'phoneNumber': phoneNumber,
    };
  }
}
