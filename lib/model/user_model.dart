class UserModel {
  late final String name;
  late final String about;
  late final String image;
  late final String createdAt;
  late final String id;
  late final String lastActive;
  late final String email;
  late final String pushToken;
  late final bool isOnline;

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
