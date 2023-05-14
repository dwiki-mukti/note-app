import 'package:flutter/material.dart';
import 'package:my_note/src/note/screen/detail.dart';
import 'package:my_note/src/note/model/index.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final Function(int) onLongPress;
  final Function(bool) onLeaveNoteDetailScreen;

  const NoteCard(
      {super.key,
      required this.note,
      required this.onLongPress,
      onLeaveNoteDetailScreen})
      : onLeaveNoteDetailScreen = onLeaveNoteDetailScreen ?? Function;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NoteDetailScreen(
              note: note,
              onLeave: onLeaveNoteDetailScreen,
            );
          }));
        },
        onLongPress: () {
          onLongPress(note.id);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(note.title),
                  ),
                  Text(
                    (note.content),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
