import 'package:equatable/equatable.dart';

class Promos extends Equatable {
  final String title;
  final String link;
  final String body;
  final String type;
  final String image;

  Promos({
    required this.image,
    required this.title,
    required this.link,
    required this.body,
    required this.type,
  });
  @override
  List<Object> get props => [image, title, link, body, type];
}
