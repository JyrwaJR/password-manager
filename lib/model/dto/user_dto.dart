class UserDTO {
  String userName;
  String email;
  String uid;
  UserDTO({
    required this.userName,
    required this.email,
    required this.uid,
  });
  // to map
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'uid': uid,
    };
  }
}
