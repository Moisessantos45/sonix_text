class EntityGrade {
  final String id;
  final String title;
  final String content;
  final String date;
  final String dueDate;
  final String status;
  final String priority;
  final String category;
  final int color;
  final int point;

  final String table;

  EntityGrade({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.dueDate,
    required this.status,
    required this.priority,
    required this.category,
    required this.color,
    required this.point,
    this.table = 'grade',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'due_date': dueDate,
      'status': status,
      'priority': priority,
      'category': category,
      'color': color.toString(),
      'point': point,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'title': title,
      'content': content,
      'due_date': dueDate,
      'status': status,
      'priority': priority,
      'category': category,
      'color': color.toString(),
      'point': point,
    };
  }

  factory EntityGrade.fromMap(Map<String, dynamic> map) {
    return EntityGrade(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      dueDate: map['due_date'],
      status: map['status'],
      priority: map['priority'],
      category: map['category'],
      color: int.tryParse(map['color']) ?? 0xFF0000FF,
      point: map['point'],
    );
  }

  EntityGrade copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
    String? dueDate,
    String? status,
    String? priority,
    String? category,
    int? color,
    int? point,
  }) {
    return EntityGrade(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      color: color ?? this.color,
      point: point ?? this.point,
    );
  }
}
