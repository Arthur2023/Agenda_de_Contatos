import 'package:flutter/material.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imageColumn = "imageColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = _initDb() as Database;
    }
  }

  Future<Database> _initDb() async {
    final DatabasePath = await getDatabasesPath();
    final Path = join(DatabasePath, "contacts.db");
    return await openDatabase(Path, version: 1,
        onCreate: (Database db, int newerversion) async {
          await db.execute(
              "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imageColumn TEXT )");
        });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, Contact.toMap());
    return contact;
  }

}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String image;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    image = map[imageColumn];

  Map toMap(){
    return {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imageColumn: image,
    };
  }

    @override
    String toString() {
      return "Contact(id: $id, name: $name,email: $email, phone: $phone, image: $image)";
    }
  }
}
