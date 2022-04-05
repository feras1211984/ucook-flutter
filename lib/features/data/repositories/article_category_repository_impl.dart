import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/features/domain/entities/articlecategory.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../domain/repositories/article_category_repository.dart';
import '../datasources/ucook_remote_data_source.dart';

typedef Future<List<ArticleCategory>> _ArticleCategoryChooser();

class ArticleCategoryRepositoryImpl implements ArticleCategoryRepository {
  final UcookRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ArticleCategoryRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<ArticleCategory>>> getArticleCategory() async {
    return await _getArticleCategory(() {
      return remoteDataSource.getArticleCategory();
    });
  }

  Future<Either<Failure, List<ArticleCategory>>> _getArticleCategory(
    _ArticleCategoryChooser getArticleCategory,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticleCategory = await getArticleCategory();
        return Right(remoteArticleCategory);
      }
      on AuthException{
        return Left(AuthFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
}
