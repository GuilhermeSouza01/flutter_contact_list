import 'dart:io';

import 'package:contact_list/models/contact.dart';
import 'package:contact_list/screens/add_contact_screen.dart';
import 'package:contact_list/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final contactService = ContactService();

  Future<void> showDeleteConfirmationDialog(ContactModel contact) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Contact"),
          content: const Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Execute the delete function
                contactService.deleteContact(contact);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("C O N T A C T L Y"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<ContactModel>('contactBox').listenable(),
              builder: (context, Box<ContactModel> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (ctx, i) {
                    final contact = box.getAt(i);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(contact!.imageUrl.toString()),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(contact.name.toString()),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(contact.email.toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(contact.phone.toString()),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final newNameController =
                                      TextEditingController(text: contact.name);
                                  final newEmailController =
                                      TextEditingController(
                                          text: contact.email);
                                  final newPhoneController =
                                      TextEditingController(
                                          text: contact.phone);
                                  final newImageUrlController =
                                      TextEditingController(
                                          text: contact.imageUrl);

                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        File? newImageFile = null;
                                        TextEditingController
                                            newImageUrlController =
                                            TextEditingController(
                                                text: contact.imageUrl);
                                        return AlertDialog(
                                          title: const Text("Edit Contact"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: newNameController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Name'),
                                                ),
                                                TextField(
                                                  controller:
                                                      newEmailController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Email'),
                                                ),
                                                TextField(
                                                  controller:
                                                      newPhoneController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Phone'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final newImage =
                                                        await ImagePicker
                                                            .platform
                                                            .getImage(
                                                                source:
                                                                    ImageSource
                                                                        .camera);
                                                    if (newImage != null) {
                                                      setState(() {
                                                        newImageFile =
                                                            File(newImage.path);
                                                        setState(() {});
                                                      });
                                                    }
                                                  },
                                                  child: const Text(
                                                      "Take a New Photo"),
                                                ),
                                                if (newImageFile != null)
                                                  Image.file(newImageFile!),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // To close the dialog
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final newContactImage =
                                                    newImageFile != null
                                                        ? newImageFile!.path
                                                        : newImageUrlController
                                                            .text;
                                                contactService.editContactInfo(
                                                  contact,
                                                  newNameController.text,
                                                  newEmailController.text,
                                                  newPhoneController.text,
                                                );
                                                //To update image separeted
                                                contactService.editContactImage(
                                                    contact, newContactImage);

                                                Navigator.of(context)
                                                    .pop(); // To close the dialog
                                              },
                                              child: const Text("Update"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  //Show the modal to confirm action of delete
                                  showDeleteConfirmationDialog(contact);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              })),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const AddContactScreen(),
              ),
            );
          },
          label: const Text("+ Add Contact")),
    );
  }
}
