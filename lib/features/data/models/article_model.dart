import 'dart:ffi';

import 'package:http/http.dart';
import 'package:ucookfrontend/core/util/input_converter.dart';

import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  ArticleModel({
    required int id,
    required String relatedId,
    required String name,
    required String name2,
    required String unit1name,
    required double unit1price,
    required String unit2name,
    required double unit2price,
    required String unit2equal,
    required String unit3name,
    required double unit3price,
    required String unit3equal,
    required String defaultunit,
    required String model,
    required String color,
    required String size,
    required double quantity,
    required String articleCategoryId,
    required String image,
    required String thumbnail,
    required String description,
  }) : super(
            id: id,
            relatedId: relatedId,
            name: name,
            articleCategoryId: articleCategoryId,
            color: color,
            defaultunit: defaultunit,
            description: description,
            image: image,
            thumbnail: thumbnail,
            model: model,
            name2: name2,
            quantity: quantity,
            size: size,
            unit1name: unit1name,
            unit1price: unit1price,
            unit2equal: unit2equal,
            unit2name: unit2name,
            unit2price: unit2price,
            unit3equal: unit3equal,
            unit3name: unit3name,
            unit3price: unit3price);

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return _$ArticleModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'relatedId': relatedId,
      'name': name,
      'articleCategoryId': articleCategoryId,
      'color': color,
      'defaultunit': defaultunit,
      'description': description,
      'image': image,
      'thumbnail': thumbnail,
      'model': model,
      'name2': name2,
      'quantity': quantity,
      'size': size,
      'unit1name': unit1name,
      'unit1price': unit1price,
      'unit2equal': unit2equal,
      'unit2name': unit2name,
      'unit2price': unit2price,
      'unit3equal': unit3equal,
      'unit3name': unit3name,
      'unit3price': unit3price
    };
  }
}

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) {
  return ArticleModel(
      id: int.parse(json['id'].toString()),
      relatedId: InputConverter().checkStringNullSafety(json['relatedId']),
      name: InputConverter().checkStringNullSafety(json['name']),
      articleCategoryId:
          InputConverter().checkStringNullSafety(json['article_category_id']),
      //color: json['color'] == null ? "" : json['color'],
      color: InputConverter().checkStringNullSafety(json['color']),
      defaultunit: InputConverter().checkStringNullSafety(json['defaultunit']),
      description: InputConverter().checkStringNullSafety(json['description']),
      image: InputConverter().checkStringNullSafety(json['image']),
      thumbnail: InputConverter().checkStringNullSafety(json['thumbnail']),
      model: InputConverter().checkStringNullSafety(json['model']),
      name2: InputConverter().checkStringNullSafety(json['name2']),
      quantity: double.parse(json['quantity']),
      size: InputConverter().checkStringNullSafety(json['size']),
      unit1name: InputConverter().checkStringNullSafety(json['unit1name']),
      unit1price: double.parse(json['unit1price']),
      unit2equal: InputConverter().checkStringNullSafety(json['unit2equal']),
      unit2name: InputConverter().checkStringNullSafety(json['unit2name']),
      unit2price: double.parse(json['unit2price']),
      unit3equal: InputConverter().checkStringNullSafety(json['unit3equal']),
      unit3name: InputConverter().checkStringNullSafety(json['unit3name']),
      unit3price: double.parse(json['unit3price']));
}
