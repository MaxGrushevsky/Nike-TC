import 'package:flutter_contacts/flutter_contacts.dart';

import '../models/friend_contact.dart';

enum ContactsAccessStatus {
  granted,
  denied,
  permanentlyDenied,
}

class ContactsService {
  ContactsService._();

  static Future<ContactsAccessStatus> requestAccess() async {
    final status = await FlutterContacts.permissions.request(PermissionType.read);

    return switch (status) {
      PermissionStatus.granted || PermissionStatus.limited =>
        ContactsAccessStatus.granted,
      PermissionStatus.permanentlyDenied ||
      PermissionStatus.restricted =>
        ContactsAccessStatus.permanentlyDenied,
      _ => ContactsAccessStatus.denied,
    };
  }

  static Future<List<FriendContact>> loadContacts() async {
    final contacts = await FlutterContacts.getAll(
      properties: {ContactProperty.phone, ContactProperty.email},
    );

    final items = contacts
        .map((contact) {
          final displayName = (contact.displayName ?? '').trim();
          if (displayName.isEmpty) {
            return null;
          }

          return FriendContact(
            id: contact.id ?? displayName,
            displayName: displayName,
            subtitle: _primarySubtitle(contact),
          );
        })
        .whereType<FriendContact>()
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    return items;
  }

  static String? _primarySubtitle(Contact contact) {
    if (contact.emails.isNotEmpty) {
      return contact.emails.first.address;
    }

    if (contact.phones.isNotEmpty) {
      return contact.phones.first.number;
    }

    return null;
  }
}
