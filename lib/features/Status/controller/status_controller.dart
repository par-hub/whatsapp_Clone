import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/Status/repository/status_repository.dart';
import 'package:whatsapp/features/auth/controller/controller.dart';
import 'package:whatsapp/models/status_model.dart';
import 'package:whatsapp/models/user_model.dart';

final statusControllerProvider =
    StateNotifierProvider<StatusController, List<Status>>((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(
    statusRepository: statusRepository,
    ref: ref,
  );
});

class StatusController extends StateNotifier<List<Status>> {
  final StatusRepository statusRepository;
  final Ref ref;
  StatusController({
    required this.statusRepository,
    required this.ref,
  }) : super([]);

  void addStatus(File file, BuildContext context, UserModel user) {
    statusRepository.uploadStatus(
      username: user.name,
      profilePic: user.profilePic,
      phoneNumber: user.phoneNumber,
      statusImage: file,
      context: context,
    );
    // Refresh the status list after upload
    getStatus(context);
  }

  void getStatus(BuildContext? context) async {
    List<Status> statuses = [];
    if (context != null) {
      statuses = await statusRepository.getStatus(context);
    }
    state = statuses;
  }
}
