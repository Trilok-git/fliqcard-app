class InterestedListParser {
  String id;
  String userId;
  String message;
  String servicename;
  String name;
  String email;
  String phone;
  String address;
  String updatedAt;
  String status;

  InterestedListParser(
      {this.id,
        this.userId,
        this.message,
        this.servicename,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.updatedAt,
        this.status});

  InterestedListParser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    message = json['message'];
    servicename = json['servicename'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['servicename'] = this.servicename;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}
