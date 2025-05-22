
class NotesModel {
  String? title;
  String? description;
  int? time;

  NotesModel({this.title, this.description, this.time});

  NotesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['time'] = this.time;
    return data;
  }

  // Convert a Note object into a Map (for JSON encoding)


}
