import 'dart:ffi';

import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final int id;
  final String relatedId;
  final String name;
  final String name2;
  final String unit1name;
  final double unit1price;
  final String unit2name;
  final double unit2price;
  final String unit2equal;
  final String unit3name;
  final double unit3price;
  final String unit3equal;
  final String defaultunit;
  final String model;
  final String color;
  final String size;
  final double quantity;
  final String articleCategoryId;
  final String image;
  final String thumbnail;
  final String description;
  int cartQuantity = 0;
  Article(
      {required this.id,
      required this.articleCategoryId,
      required this.color,
      required this.defaultunit,
      required this.description,
      required this.image,
      required this.thumbnail,
      required this.model,
      required this.name,
      required this.name2,
      required this.quantity,
      required this.relatedId,
      required this.size,
      required this.unit1name,
      required this.unit1price,
      required this.unit2equal,
      required this.unit2name,
      required this.unit2price,
      required this.unit3equal,
      required this.unit3name,
      required this.unit3price});
  @override
  List<Object> get props => [
        id,
        articleCategoryId,
        color,
        defaultunit,
        description,
        image,
        thumbnail,
        model,
        name,
        name2,
        quantity,
        relatedId,
        size,
        unit1name,
        unit1price,
        unit2equal,
        unit2name,
        unit2price,
        unit3equal,
        unit3name,
        unit3price
      ];
}
