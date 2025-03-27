import 'package:sonix_text/domains/entity_category.dart';

class CategoryModel extends EntityCategory {
  CategoryModel({
    required super.id,
    required super.name,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
    };
  }
}
