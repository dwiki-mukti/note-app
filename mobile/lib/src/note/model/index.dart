import 'dart:convert';

class NoteModel {
  int id;
  String title;
  String content;

  NoteModel({this.id = 0, this.title = '', this.content = ''});

  factory NoteModel.fromJson(Map<String, dynamic> jsonNote) {
    return NoteModel(
        id: jsonNote['id'],
        title: jsonNote['title'],
        content: jsonNote['content']);
  }
}

List<NoteModel> noteFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<NoteModel>.from(data.map((item) => NoteModel.fromJson(item)))
      .toList();
}
