import 'package:flutter/material.dart';
import 'package:school_pags/screens/add_edit.dart';
import 'package:school_pags/screens/view_note_screen.dart';
import 'package:school_pags/model/notes_model.dart';
import 'package:school_pags/services/database_helpar.dart';
//import 'package:school_pags/services/database_helper.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
        backgroundColor: Colors.deepPurple, // Updated AppBar color
      ),
      body: _notes.isEmpty
          ? Center(
              child: Text(
                'No notes added yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                final color = Color(int.parse(note.color));

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewNoteScreen(note: note),
                      ),
                    );
                    _loadNotes();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(2, 4), // Position of shadow
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.9),
                          color.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          note.content,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          _formatDateTime(note.dateTime),
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEdit(),
            ),
          );
          _loadNotes();
        },
        backgroundColor: Colors.deepPurple, // Button color
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
