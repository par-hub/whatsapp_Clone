import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp/models/chat_contacts.dart';
import 'package:whatsapp/models/group.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Group>>(
                stream: ref.watch(chatControllerProvider).chatGroups(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MobileChatScreen.routeName,
                                  arguments: {
                                    'name': groupData.name,
                                    'uid': groupData.groupId,
                                    'isGroupChat': true,
                                    'profilePic': groupData.groupPic,
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                  title: Text(
                                    groupData.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      groupData.lastMessage,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(groupData.groupPic),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm().format(groupData.timeSent),
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  )),
                            ),
                          ),
                          Divider(
                            color: dividerColor,
                            indent: 85,
                          )
                        ],
                      );
                    },
                  );
                }),
            StreamBuilder<List<ChatContacts>>(
                stream: ref.watch(chatControllerProvider).chatContacts(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var chatContactData = snapshot.data![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name': chatContactData.name,
                                  'uid': chatContactData.contactId,
                                  'isGroupChat': false,
                                  'profilePic': chatContactData.profilePic,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                  title: Text(
                                    chatContactData.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      chatContactData.lastMessage,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        chatContactData.profilePic),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm()
                                        .format(chatContactData.timeSent),
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  )),
                            ),
                          ),
                          Divider(
                            color: dividerColor,
                            indent: 85,
                          )
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
