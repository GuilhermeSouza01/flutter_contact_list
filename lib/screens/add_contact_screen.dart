import 'dart:io';

import 'package:contact_list/models/contact.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+55 (xx) xxxxx-xxxx',
    filter: {"x": RegExp(r'[0-9]')},
  );

  XFile? _image;
  String? name;
  String? email;
  String? phone;

  getImage() async {
    final image =
        await ImagePicker.platform.getImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  submitData() async {
    final isValid = await _formKey.currentState!.validate();

    if (isValid) {
      Hive.box<ContactModel>('contactBox').add(
        ContactModel(
            name: name, email: email, phone: phone, imageUrl: _image!.path),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a contact"),
        actions: [IconButton(onPressed: submitData, icon: Icon(Icons.save))],
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Name"),
                  ),
                  autocorrect: false,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Email"),
                  ),
                  autocorrect: false,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Phone"),
                  ),
                  autocorrect: false,
                  inputFormatters: [phoneMaskFormatter],
                  onChanged: (value) {
                    setState(() {
                      phone = phoneMaskFormatter.getUnmaskedText();
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                _image == null
                    ? Container()
                    : Image.file(
                        File(_image!.path),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
