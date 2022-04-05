import '../../domain/entities/promos.dart';

class PromosModel extends Promos {
  PromosModel(
      {required String title,
      required String link,
      required String body,
      required String type,
      required String image})
      : super(title: title, link: link, body: body, type: type, image: image);
  factory PromosModel.fromJson(Map<String, dynamic> json) {
    return PromosModel(
      title: json['title'],
      link: json['link'],
      body: json['body'],
      type: json['type'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'body': body,
      'type': type,
      'image': image,
    };
  }
}
