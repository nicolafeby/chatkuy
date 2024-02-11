class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final DateTime lastActive;
  final bool isOnline;
  final String userName;

  const UserModel({
    required this.userName,
    required this.name,
    required this.image,
    required this.lastActive,
    required this.uid,
    required this.email,
    this.isOnline = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        name: json['name'],
        image: json['image'],
        email: json['email'],
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
        userName: json['userName'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'image': image,
        'email': email,
        'isOnline': isOnline,
        'lastActive': lastActive,
        'userName': userName,
      };
}
