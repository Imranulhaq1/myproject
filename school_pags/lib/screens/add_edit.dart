import 'package:flutter/material.dart';
import 'package:school_pags/model/notes_model.dart';
import 'package:school_pags/services/database_helpar.dart';

class AddEdit extends StatefulWidget {
  final Note? note;

  const AddEdit({Key? key, this.note}) : super(key: key);

  @override
  State<AddEdit> createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.title, color: Colors.blue),
                    filled: true,
                    fillColor: Colors
                        .transparent, // Transparent to show container color
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a title'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              // Content Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.notes, color: Colors.green),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter content'
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  shadowColor: Colors.deepOrangeAccent,
                  elevation: 6,
                ),
                child: Text(
                  widget.note == null ? 'Add Note' : 'Update Note',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: Colors.amber.value.toString(),
        dateTime: DateTime.now().toString(),
      );
      if (widget.note == null) {
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }
      Navigator.pop(context);
    }
  }
}
