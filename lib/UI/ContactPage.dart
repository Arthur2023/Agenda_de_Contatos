import 'dart:io';
import 'package:agenda_de_contatos_udemy/Helpers/ContactHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await _requestPop();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink[900],
            title: Text(
              _editedContact.name ?? "Novo contato",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15, 25, 15, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _editedContact.image != null
                            ? FileImage(File(_editedContact.image))
                            : AssetImage("images/contact.png"),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                  onTap: () {
                    return _showPhoto();
                  },
                ),
                TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(labelText: "Nome"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(
                        () {
                          _editedContact.name = text;
                        },
                      );
                    }),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedContact.email = text;
                      },
                      keyboardType: TextInputType.emailAddress,
                    )),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Phone"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name != null &&
                  _editedContact.name.isNotEmpty) {
                _editedContact.name = _nameController.text;
                _editedContact.email = _emailController.text;
                _editedContact.phone = _phoneController.text;
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            backgroundColor: Colors.pink[900],
            child: Icon(Icons.save),
          ),
        ));
  }

  Future<bool> _requestPop() async {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirmar"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  _showPhoto() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 60),
                child: Text(
                  "Escolha a fonte da Imagem",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 5, 25),
                    child: FlatButton(
                      child: Icon(
                        Icons.camera,
                        color: Colors.deepPurple,
                        size: 50,
                      ),
                      onPressed: () {
                        ImagePicker.pickImage(source: ImageSource.camera)
                            .then((file) {
                          if (file == null) return;
                          setState(() {
                            _editedContact.image = file.path;
                          });
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 10, 25),
                    child: FlatButton(
                      child:
                          Icon(Icons.save, color: Colors.deepPurple, size: 50),
                      onPressed: () {
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((file) {
                          if (file == null) return;
                          setState(() {
                            _editedContact.image = file.path;
                          });
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ));
        });
  }
}
