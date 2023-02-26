class ProductsListParser {
  String id;
  String userId;
  String title;
  String description;
  String imagePath;
  String videoPath;
  String price;
  String updatedAt;

  ProductsListParser(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.imagePath,
        this.videoPath,
        this.price,
        this.updatedAt});

  ProductsListParser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    imagePath = json['imagePath'];
    videoPath = json['videoPath'];
    price = json['price'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imagePath'] = this.imagePath;
    data['videoPath'] = this.videoPath;
    data['price'] = this.price;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
