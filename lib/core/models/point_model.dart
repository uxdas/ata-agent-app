// 📄 lib/models/point_model.dart

class PointModel {
  final String name;
  final String address;
  final String category;

  PointModel({
    required this.name,
    required this.address,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'category': category,
    };
  }
}
