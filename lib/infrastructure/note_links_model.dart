import 'package:sonix_text/domains/entity_note_links.dart';

class NoteLinksModel extends EntityNoteLinks {
  NoteLinksModel({
    required super.id,
    required super.fromId,
    required super.toId,
    required super.createdAt,
  });

  factory NoteLinksModel.fromJson(Map<String, dynamic> json) {
    return NoteLinksModel(
      id: json['id'],
      fromId: json['from_id'],
      toId: json['to_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from_id': fromId,
      'to_id': toId,
      'created_at': createdAt,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'to_id': toId,
    };
  }
}
