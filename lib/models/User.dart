// user_model.dart
class UserModel {
  String id;
  String name;
  int highScore;
  int gems;

  UserModel({
    required this.id,
    required this.name,
    this.highScore = 0,
    this.gems = 0,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'highScore': highScore, 'gems': gems};
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      highScore: map['highScore'] ?? 0,
      gems: map['gems'] ?? 0,
    );
  }
}
