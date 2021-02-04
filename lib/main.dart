import "package:flutter/material.dart";
import 'UI/HomePage.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Agenda de contatos",
      home: HomePage(),
    ),
  );
}
