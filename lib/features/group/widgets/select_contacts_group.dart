import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/widgets/contact_list.dart';
import 'package:whatsapp/features/select_contacts/controller/select_contacts_controller.dart';

final SelectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(SelectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (ContactList) => Expanded(
              child: ListView.builder(
                  itemCount: ContactList.length,
                  itemBuilder: (context, index) {
                    final contact = ContactList[index];
                    return InkWell(
                      onTap: () => selectContact(index, contact),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(fontSize: 18),
                          ),
                          leading: selectedContactsIndex.contains(index)
                              ? const CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    );
                  })),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const Loader(),
        );
  }
}
