import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/common/provider/message_reply.dart';
import 'package:whatsapp/common/utils/enums/message_enums.dart';
import 'package:whatsapp/common/widgets/loader.dart';

import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/features/chat/widgets/My_card__message.dart';
import 'package:whatsapp/features/chat/widgets/sender_card_Message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnums messageEnums) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            messageEnums: messageEnums,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: widget.isGroupChat
          ? ref
              .read(chatControllerProvider)
              .groupchatStream(widget.recieverUserId)
          : ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        // ✅ Prevent crash when no messages
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No messages yet...",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // ✅ Safe scroll
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (messageController.hasClients) {
            messageController.jumpTo(
              messageController.position.maxScrollExtent,
            );
          }
        });

        final messages = snapshot.data!;

        return ListView.builder(
          controller: messageController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);

            // ✅ Mark as seen
            if (!messageData.isSeen &&
                messageData.recieverid ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context,
                    widget.recieverUserId,
                    messageData.messageId,
                  );
            }

            // ✅ Current user's message
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyCardMessage(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                onLeftSwipe: () =>
                    onMessageSwipe(messageData.text, true, messageData.type),
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                isSeen: messageData.isSeen,
              );
            }

            // ✅ Other sender's message
            return SenderCardMessage(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              onRightSwipe: () =>
                  onMessageSwipe(messageData.text, false, messageData.type),
              repliedText: messageData.repliedMessage,
              username: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
            );
          },
        );
      },
    );
  }
}
