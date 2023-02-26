class ServicesListParser {
  String id;
  String userId;
  String title;
  String description;
  String imagePath;
  String videoPath;
  String updatedAt;

  ServicesListParser(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.imagePath,
        this.videoPath,
        this.updatedAt});

  ServicesListParser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    imagePath = json['imagePath'];
    videoPath = json['videoPath'];
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
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
