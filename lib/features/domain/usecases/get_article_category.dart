import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/articlecategory.dart';
import '../repositories/article_category_repository.dart';

class GetArticleCategoryUseCase implements UseCase<List<ArticleCategory>, NoParams> {
  final ArticleCategoryRepository repository;

  GetArticleCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleCategory>>> call(NoParams params) async {
    return await repository.getArticleCategory();
  }
}
