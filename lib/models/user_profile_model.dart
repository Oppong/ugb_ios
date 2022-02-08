class UserProfileModel {
  UserProfileModel({
    this.email,
    this.fullName,
    this.imageUrl,
    this.userId,
    this.userType,
    this.createdAt,
    this.studentId,
    this.programme,
  });

  String? fullName, email, imageUrl, userId, userType, studentId, programme;
  DateTime? createdAt;
}
