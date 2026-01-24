// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/enums/message_enums.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnums messageEnums;
  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageEnums,
  });
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
