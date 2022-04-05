import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/promos.dart';

abstract class PromosRepository {
  Future<Either<Failure, List<Promos>>> getPromos();
}
