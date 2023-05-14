import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_note/src/note/model/index.dart';

class NoteDetailScreen extends StatefulWidget {
  // attribbute
  final NoteModel note;

  // counstruct
  NoteDetailScreen({super.key, note})
      : note = note ?? NoteModel(id: 0, content: "", title: "");
  // const NoteDetailScreen({super.key, required this.note});

  // view
  @override
  State<NoteDetailScreen> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetailScreen> {
  // attribute
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerContent = TextEditingController();
  bool isSync = true;
  Timer? debounce;

  // method
  syncBackend(String query) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      String title = controllerTitle.text.toString();
      String content = controllerContent.text.toString();

      // hit BE
      if (widget.note.id > 0) {
        http
            .put(Uri.parse('http://127.0.0.1:3000/note/${widget.note.id}'),
                headers: {"Content-Type": "application/json; charset=UTF-8"},
                body: jsonEncode(({"title": title, "content": content})))
            .then((value) {
          log('response sync note (on NoteDetailScreen): ${value.body}');

          return value;
        });
      } else {
        http
            .post(Uri.parse('http://127.0.0.1:3000/note'),
                headers: {"Content-Type": "application/json; charset=UTF-8"},
                body: jsonEncode(({"title": title, "content": content})))
            .then((value) {
          log('response sync note (on NoteDetailScreen): ${value.body}');

          return value;
        });
      }
    });
  }

  // onDidMount
  @override
  void initState() {
    controllerTitle.text = widget.note.title;
    controllerContent.text = widget.note.content;
    super.initState();
  }

  // onMount
  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  // view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controllerTitle,
              onChanged: syncBackend,
              maxLines: 1,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration.collapsed(hintText: "Judul"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                controller: controllerContent,
                onChanged: syncBackend,
                minLines: 5,
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration.collapsed(
                    hintText: "Enter your text here"),
              ),
            )
          ],
        ),
      )),
    );
    ;
  }
}
