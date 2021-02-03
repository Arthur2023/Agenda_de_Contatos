import 'package:flutter/material.dart';
import '../Helpers/ContactHelper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();
    /* Contact c = Contact();
  c.name = "Jeffery";
  c.email = "jeffery@terra.com";
  c.phone = "912345678";
  c.image = "imageTest";

  helper.saveContact(c);*/

    helper.getAllContacts().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
