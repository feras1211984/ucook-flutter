import 'package:equatable/equatable.dart';

class ArticleCategory extends Equatable {
  final String image;
  final String name;
  final String name2;
  final String relatedId;
  final String clientId;
  final int id;
  ArticleCategory({
    required this.image,
    required this.name,
    required this.name2,
    required this.relatedId,
    required this.clientId,
    required this.id
  });
  @override
  List<Object> get props => [image, name, name2, relatedId, clientId,id];
}
