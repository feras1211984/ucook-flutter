import 'package:ucookfrontend/core/util/input_converter.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';

class ArticleMediaModel extends ArticleMedia {
  ArticleMediaModel({
    required String type,
    required String link,
  }) : super(
          type: type,
          link: link,
        );

  factory ArticleMediaModel.fromJson(Map<String, dynamic> json) {
    return _$ArticleMediaModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'link': link,
    };
  }
}

ArticleMediaModel _$ArticleMediaModelFromJson(Map<String, dynamic> json) {
  return ArticleMediaModel(
      link: json['link'].toString().startsWith('https') == true
          ? InputConverter()
              .checkStringNullSafety(json['link'])
              .replaceAll(RegExp(r'storage'), 'public')
          : 'https://ucook.alkhazensoft.net/storage/' +
              InputConverter().checkStringNullSafety(json['link']),
      type: InputConverter().checkStringNullSafety(json['type']));
}
