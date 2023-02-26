class ProductEnquiryListParser {
  String id;
  String userId;
  String orderId;
  String message;
  String name;
  String email;
  String phone;
  String address;
  String totalAmount;
  String updatedAt;
  String status;

  ProductEnquiryListParser(
      {this.id,
        this.userId,
        this.orderId,
        this.message,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.totalAmount,
        this.updatedAt,
        this.status});

  ProductEnquiryListParser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    message = json['message'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    totalAmount = json['total_amount'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['message'] = this.message;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['total_amount'] = this.totalAmount;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}
