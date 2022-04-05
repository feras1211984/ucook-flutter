import '../../domain/entities/articlecategory.dart';

class ArticleCategoryModel extends ArticleCategory {
  ArticleCategoryModel({
    required String image,
    required String name,
    required String name2,
    required String relatedId,
    required String clientId,
    required int id,
  }) : super(
            clientId: clientId,
            image: image,
            name: name,
            name2: name2,
            relatedId: relatedId,
            id: id);

  factory ArticleCategoryModel.fromJson(Map<String, dynamic> json) {
    return _$BeerModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'relatedId': relatedId,
      'clientId': clientId,
      'name2': name2,
      'image': image,
      'name': name,
      'id': id,
    };
  }
}

ArticleCategoryModel _$BeerModelFromJson(Map<String, dynamic> json) {
  return ArticleCategoryModel(
      relatedId: json['relatedId'] == null ? "0" : json['relatedId'],
      clientId: json['clientId'] == null ? "0" : json['clientId'],
      name2: json['name2'] == null ? "" : json['name2'],
      image: json['image'] == null ? "" : json['image'],
      name: json['name'] == null ? "" : json['name'],
      id: json['id'] == null ? 0 : int.parse(json['id'].toString()));
}
