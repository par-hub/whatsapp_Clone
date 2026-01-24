import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/Status/controller/status_controller.dart';
import 'package:whatsapp/features/auth/controller/controller.dart';

class ComfirmStatus extends ConsumerWidget {
  static const String routeName = '/confirm-status-screen';
  final File file;
  const ComfirmStatus(this.file, {super.key});

  void addStatus(WidgetRef ref, BuildContext context) {
    print("✅ addStatus called"); // add this
    final userAsync = ref.watch(userDataAuthProvider);
    if (userAsync is AsyncData) {
      final user = userAsync.value;
      if (user != null) {
        ref
            .read(statusControllerProvider.notifier)
            .addStatus(file, context, user);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(ref, context),
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        backgroundColor: tabColor,
      ),
    );
  }
}
