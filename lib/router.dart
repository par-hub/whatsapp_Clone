import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/features/Status/screens/comfirm_status.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/sign_up.dart';
import 'package:whatsapp/features/auth/screens/user_information.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/group/screens/create_group_screen.dart';
import 'package:whatsapp/features/select_contacts/screens/select_contacts_screens.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp/features/call/screen/call_screen.dart';
import 'package:whatsapp/screens/mobilescreen_layout.dart';
import 'package:whatsapp/models/call.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case SignUp.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignUp(),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case MobilescreenLayout.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobilescreenLayout(),
      );
    case SelectContactsScreens.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreens(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    case ComfirmStatus.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ComfirmStatus(file),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
    case CallScreen.routeName:
      final call = settings.arguments as Call;
      return MaterialPageRoute(
        builder: (context) => CallScreen(call: call, isGroupChat: false),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
