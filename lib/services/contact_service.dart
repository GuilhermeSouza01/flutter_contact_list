import 'package:contact_list/models/contact.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ContactService {
  Future<void> editContactInfo(ContactModel contact, String newName,
      String newEmail, String newPhone) async {
    final contactsBox = await Hive.openBox<ContactModel>('contactBox');
    final contactIndex =
        contactsBox.values.toList().indexWhere((c) => c.key == contact.key);

    if (contactIndex >= 0) {
      final editedContact = ContactModel(
        name: newName,
        email: newEmail,
        phone: newPhone,
        imageUrl: contact.imageUrl,
        key: contact.key,
      );

      await contactsBox.putAt(contactIndex, editedContact);
    }
  }

  Future<void> editContactImage(
      ContactModel contact, String newImageUrl) async {
    final contactsBox = await Hive.openBox<ContactModel>('contactBox');
    final contactIndex =
        contactsBox.values.toList().indexWhere((c) => c.key == contact.key);

    if (contactIndex >= 0) {
      final editedContact = ContactModel(
        name: contact.name,
        email: contact.email,
        phone: contact.phone,
        imageUrl: newImageUrl,
        key: contact.key,
      );

      await contactsBox.putAt(contactIndex, editedContact);
    }
  }

  Future<void> deleteContact(ContactModel contact) async {
    final contactsBox = await Hive.openBox<ContactModel>('contactBox');
    final contactIndex =
        contactsBox.values.toList().indexWhere((c) => c.key == contact.key);

    if (contactIndex >= 0) {
      await contactsBox.deleteAt(contactIndex);
    }
  }
}
