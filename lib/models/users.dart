class UserResponse {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<User>? data;

  UserResponse({this.statusCode, this.success, this.messages, this.data});

  UserResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = List<String>.from(json['messages'] ?? []);
    data = (json['data'] as List<dynamic>?)
        ?.map((item) => User.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['statusCode'] = statusCode;
    json['success'] = success;
    json['messages'] = messages;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class User {
  int? userId;
  String? username;
  String? email;
  String? userRole;
  bool? userStatus;
  String? mobileNo;
  String? profilePic;
  String? createdAt;


  var data;

  User({
    this.userId,
    this.username,
    this.email,
    this.userRole,
    this.userStatus,
    this.mobileNo,
    this.profilePic,
    this.createdAt
  });

   User.fromJson(Map<String, dynamic> json) {
    // Ensure correct type assignment and type conversion where necessary
    userId = json['user_id'] ;
    username = json['username']?.toString();
    email = json['email']?.toString();
    userRole = json['user_role']?.toString();
    userStatus = json['user_status']; // Convert 1/0 to true/false
    mobileNo = json['mobile_no']?.toString(); // Convert to string if necessary
    profilePic = json['profile_pic']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['user_role'] = userRole;
    data['user_status'] = userStatus ; // Convert bool to int
    data['mobile_no'] = mobileNo;
    data['profile_pic'] = profilePic;
    data['created_at'] = createdAt;
    return data;
  }

  @override
  String toString() {
    return 'User(userId: $userId, username: $username, email: $email, userRole: $userRole, userStatus: $userStatus, mobileNo: $mobileNo, profilePic: $profilePic,createdAt:$createdAt )';
  }
}
extension UserCopyWith on User {
  User copyWith({String? profilePic}) {
    return User(
      userId: userId,
      username: username,
      email: email,
      userRole: userRole,
      userStatus: userStatus,
      mobileNo: mobileNo,
      profilePic: profilePic ?? this.profilePic,
      createdAt :createdAt ?? createdAt
    );
  }
}
