import 'package:flutter/material.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/pages/detail_note_page.dart';
import 'package:note_app/pages/notes_page.dart';

import 'model/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: const Color(0xFF252525),
        brightness: Brightness.dark,
      ),
      home: const NotesPage()
    );
  }
}
