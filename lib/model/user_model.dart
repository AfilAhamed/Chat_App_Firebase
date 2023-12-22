class FireStoreModel {
  final String name;
  final String about;
  final String image;
  final String createdAt;
  final String id;
  final String lastActive;
  final String email;
  final String pushToken;
  final bool isOnline;

  FireStoreModel(
      {required this.name,
      required this.about,
      required this.image,
      required this.createdAt,
      required this.id,
      required this.lastActive,
      required this.email,
      required this.pushToken,
      required this.isOnline});
}
