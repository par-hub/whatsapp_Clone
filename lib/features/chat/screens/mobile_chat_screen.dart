// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/controller.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/features/call/screen/call_screen.dart';
import 'package:whatsapp/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  void makeCall(WidgetRef ref, BuildContext context) async {
    final call = await ref
        .read(callControllerProvider)
        .makeCall(context, name, uid, profilePic, isGroupChat);
    if (call != null) {
      Navigator.pushNamed(context, CallScreen.routeName, arguments: call);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream: ref.read(authControllerProvider).userDataById(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  return Column(
                    children: [
                      Text(name),
                      Text(
                        snapshot.data!.isOnline ? 'online' : 'offline',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  );
                }),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => makeCall(ref, context),
              icon: const Icon(Icons.video_call)),
          IconButton(
            onPressed: () {
              // TODO: Implement voice call if needed
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatList(
            recieverUserId: uid,
            isGroupChat: isGroupChat,
          )),
          BottomChatField(
            recieverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
