class EntityGrade {
  final String id;
  final String title;
  final String content;
  final String date;
  final String dueDate;
  final String status;
  final String priority;
  final String category;
  final String color;
  final int point;

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
      'color': color,
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
      'color': color,
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
      color: map['color'],
      point: map['point'],
    );
  }
}
