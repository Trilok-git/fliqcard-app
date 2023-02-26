class FollowupListParser {
  String id;
  String userId;
  String vcardId;
  String name;
  String email;
  String phone;
  String createdAt;
  String about;
  String status;
  String profileImagePath;

  FollowupListParser(
      {this.id,
      this.userId,
      this.vcardId,
      this.name,
      this.email,
      this.phone,
      this.createdAt,
      this.about,
      this.status,
      this.profileImagePath});

  FollowupListParser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vcardId = json['vcardId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    createdAt = json['created_at'];
    about = json['about'];
    status = json['status'];
    profileImagePath = json['profileImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['vcardId'] = this.vcardId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['about'] = this.about;
    data['status'] = this.status;
    data['profileImagePath'] = this.profileImagePath;
    return data;
  }
}
