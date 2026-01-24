import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/select_contacts/repository/select_contacts_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final SelectContactsRepository = ref.watch(SelectContactsRepositoryProvider);
  return SelectContactsRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactsRepository = ref.watch(SelectContactsRepositoryProvider);
  return SelectedContactController(selectContactsRepository, ref: ref);
});

class SelectedContactController {
  final SelectContactsRepository selectContactsRepository;
  final Ref ref;

  SelectedContactController(this.selectContactsRepository, {required this.ref});

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.SelectContact(selectedContact, context);
  }
}
