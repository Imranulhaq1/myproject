import 'package:flutter/material.dart';
import 'package:school_pags/model/notes_model.dart';
import 'package:school_pags/screens/add_edit.dart';
import 'package:school_pags/services/database_helpar.dart';

class ViewNoteScreen extends StatelessWidget {
  final Note note;
  final DatabaseHelper _databaseHelper =
      DatabaseHelper.instance; // Singleton instance

  ViewNoteScreen({super.key, required this.note});

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEdit(note: note),
                ),
              );
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              final confirm = await _showDeleteDialog(context);
              if (confirm == true) {
                await _databaseHelper.deleteNote(note.id!);
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the formatted date at the top
            Text(
              _formatDateTime(note.dateTime),
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 16),
            // Container for note content
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Note title
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Note content
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Note"),
        content: Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
