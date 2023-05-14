import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_note/src/note/screen/detail.dart';
import 'package:my_note/src/note/model/index.dart';
import 'package:my_note/src/note/widget/note_card.dart';

class NoteScreenIndex extends StatefulWidget {
  const NoteScreenIndex({super.key});

  @override
  State<NoteScreenIndex> createState() => _NoteScreenIndexState();
}

class _NoteScreenIndexState extends State<NoteScreenIndex> {
  // declare function fetcher notes
  Future<List<NoteModel>> fetchNotes() async {
    log('geting data notes (on NoteScreenIndex)');
    final response = await http.get(Uri.parse('http://127.0.0.1:3000/note'));
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      log('response data notes (on NoteScreenIndex): ${decodedResponse['notes']}');
      List<NoteModel> dataNotes = (decodedResponse['notes'] as List)
          .map((item) => NoteModel.fromJson(item))
          .toList();

      return dataNotes;
    } else {
      throw Exception({"message": "Failed to load News"});
    }
  }

  Future<List<NoteModel>> deleteNews() async {
    log('start delete note (on NoteScreenIndex)');
    final response =
        await http.delete(Uri.parse('http://127.0.0.1:3000/note/$idDeleted'));
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      log('response delete data notes (on NoteScreenIndex): ${decodedResponse['notes']}');
      List<NoteModel> dataNotes = (decodedResponse['notes'] as List)
          .map((item) => NoteModel.fromJson(item))
          .toList();
      setState(() {
        idDeleted = 0;
      });

      return dataNotes;
    } else {
      throw Exception({"message": "Failed to load News"});
    }
  }

  // init var list notes
  late Future<List<NoteModel>> notes;
  int idDeleted = 0;

  @override
  void initState() {
    notes = fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
        actions: (idDeleted > 0)
            ? ([
                InkWell(
                    onTap: () {
                      setState(() {
                        idDeleted = 0;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text("CANCEL",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )),
                InkWell(
                  onTap: () {
                    setState(() {
                      notes = deleteNews();
                    });
                  },
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child:
                            Text("DELETE", style: TextStyle(color: Colors.red)),
                      )),
                )
              ])
            : [],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: notes,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: (snapshot.data as List).length,
                    itemBuilder: (ctx, index) {
                      return NoteCard(
                        note: (snapshot.data as List)[index],
                        onLongPress: (noteId) {
                          setState(() {
                            idDeleted = noteId;
                          });
                        },
                        onLeaveNoteDetailScreen: (val) {
                          if (val) {
                            setState(() {
                              notes = fetchNotes();
                            });
                          }
                        },
                      );
                    });
              } else {
                return Text('error: ${snapshot.error}');
              }
            }),
          )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NoteDetailScreen(onLeave: (val) {
                if (val) {
                  setState(() {
                    notes = fetchNotes();
                  });
                }
              });
            }));
          }),
    );
  }
}
