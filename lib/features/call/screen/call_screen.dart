import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/config/zego_config.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'package:whatsapp/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  static const routeName = '/call';
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    Key? key,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isCaller = currentUserId == widget.call.callerId;
    final userID = isCaller ? widget.call.callerId : widget.call.receiverId;
    final userName =
        isCaller ? widget.call.callerName : widget.call.receiverName;
    final profilePic =
        isCaller ? widget.call.callerPic : widget.call.receiverPic;
    final callStatus = isCaller ? 'Calling...' : 'Connected';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profilePic),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  callStatus,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.call_end, color: Colors.red),
          ),
        ],
      ),
      body: ZegoUIKitPrebuiltCall(
        appID: int.parse(ZegoConfig.appId),
        appSign: ZegoConfig.appSign,
        callID: widget.call.callId,
        userID: userID,
        userName: userName,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
