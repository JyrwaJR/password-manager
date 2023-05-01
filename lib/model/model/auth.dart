class AuthUser {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final bool? emailVerified;
  final bool? isAnonymous;

  AuthUser(
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.emailVerified,
    this.isAnonymous,
  );
}
