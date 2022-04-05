import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/articlecategory.dart';

abstract class ArticleCategoryRepository {
  Future<Either<Failure, List<ArticleCategory>>> getArticleCategory();
}
