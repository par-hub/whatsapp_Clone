import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/utils/util.dart';
import 'package:whatsapp/features/Status/screens/comfirm_status.dart';
import 'package:whatsapp/features/Status/screens/status_contacts_screens.dart';
import 'package:whatsapp/features/auth/controller/controller.dart';
import 'package:whatsapp/features/call/screen/call_history_screen.dart';
import 'package:whatsapp/features/call/screen/call_pickup_screen.dart';
import 'package:whatsapp/features/group/screens/create_group_screen.dart';
import 'package:whatsapp/features/select_contacts/screens/select_contacts_screens.dart';
import 'package:whatsapp/features/chat/widgets/contact_list.dart';

class MobilescreenLayout extends ConsumerStatefulWidget {
  static const routeName = '/mobile-screen';
  const MobilescreenLayout({super.key});

  @override
  ConsumerState<MobilescreenLayout> createState() => _MobilescreenLayoutState();
}

class _MobilescreenLayoutState extends ConsumerState<MobilescreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallPickupScreen(
      DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0,
            title: const Text(
              "Whatsapp",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  )),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text(
                      'Create Group',
                    ),
                    onTap: () => Future(
                      () => Navigator.pushNamed(
                          context, CreateGroupScreen.routeName),
                    ),
                  )
                ],
              )
            ],
            bottom: TabBar(
                controller: tabBarController,
                indicatorColor: tabColor,
                indicatorWeight: 4,
                labelColor: tabColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                    text: "CHATS",
                  ),
                  Tab(
                    text: "STATUS",
                  ),
                  Tab(
                    text: "CALLS",
                  )
                ]),
          ),
          body: TabBarView(controller: tabBarController, children: const [
            ContactList(),
            StatusContactsScreen(),
            CallHistoryScreen(),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (tabBarController.index == 0) {
                Navigator.pushNamed(context, SelectContactsScreens.routeName);
              } else {
                File? pickedImage = await pickImageFromGallery(context);
                if (pickedImage != null) {
                  Navigator.pushNamed(
                    context,
                    ComfirmStatus.routeName,
                    arguments: pickedImage,
                  );
                }
              }
            },
            backgroundColor: tabColor,
            child: Icon(
              Icons.comment,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
