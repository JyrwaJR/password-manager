class GroupPasswordDTO {
  final String groupId;
  final String groupName;
  final String dateCreated;
  final String uid;
  final String key;
  GroupPasswordDTO({
    required this.groupId,
    required this.groupName,
    required this.dateCreated,
    required this.uid,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'dateCreated': dateCreated,
      'uid': uid,
      'key': key,
    };
  }
}
