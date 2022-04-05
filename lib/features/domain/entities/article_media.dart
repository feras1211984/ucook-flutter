import 'package:equatable/equatable.dart';

class ArticleMedia extends Equatable {
  final String type;
  final String link;
  ArticleMedia({
    required this.type,
    required this.link,
  });
  @override
  List<Object> get props => [type, link];
}
