class UserModel {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final String phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    this.phoneNumber = '',
  });
}
