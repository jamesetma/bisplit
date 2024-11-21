class UserModel {
  String? id;
  String? email;
  String? displayName;
  String? photoUrl;

  UserModel({
    this.id,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserModel.fromDocument(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['id'],
      email: doc['email'],
      displayName: doc['displayName'],
      photoUrl: doc['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
