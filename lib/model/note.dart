import 'package:note_app/db/notes_db_helper.dart';

class Note {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({int? id,
    String? title,
    String? description,
    DateTime? createdTime,}) =>
      Note(
        id: id ?? this.id,
        title: title??this.title,
        description: description??this.description,
        createdTime: createdTime??this.createdTime,
      );

  Map<String, Object?> toJson() =>
      {
        NotesDatabase.instance.id: id,
        NotesDatabase.instance.title: title,
        NotesDatabase.instance.description: description,
        NotesDatabase.instance.time: createdTime.toIso8601String(),
      };

  static Note fromJson(Map<String, Object?> json) =>
      Note(
        id: json[NotesDatabase.instance.id] as int?,
        title: json[NotesDatabase.instance.title] as String,
        description: json[NotesDatabase.instance.description] as String,
        createdTime: DateTime.parse(json[NotesDatabase.instance.time] as String),
      );
}