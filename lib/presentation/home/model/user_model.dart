class UserModel {
  final String firstName;
  final String lastName;
  final String age;
  final String email;
  final String image;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.image,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      age: json["age"],
      email: json["email"],
      image: json["image"],
    );
  }
}
