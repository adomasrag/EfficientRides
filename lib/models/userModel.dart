class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String id;
  final String profileImage;
  final int phone;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.id,
      required this.profileImage,
      required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        id: json['id'],
        profileImage: json['profileImage'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'id': id,
        'profileImage': profileImage,
        'phone': phone,
      };
}
