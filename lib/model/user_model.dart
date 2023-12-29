class UserModel {
  late String name;
  late String about;
  late String image;
  late String createdAt;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late bool isOnline;

  UserModel(
      {required this.name,
      required this.about,
      required this.image,
      required this.createdAt,
      required this.id,
      required this.lastActive,
      required this.email,
      required this.pushToken,
      required this.isOnline});

  UserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    about = json['about'] ?? "";
    name = json['name'] ?? "";
    createdAt = json['created_at'] ?? "";
    id = json['id'] ?? "";
    isOnline = json['is_online'] ?? "";
    lastActive = json['last_active'] ?? "";
    pushToken = json['push_token'] ?? "";
    email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
