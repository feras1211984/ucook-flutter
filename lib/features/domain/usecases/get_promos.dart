import 'package:dartz/dartz.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/features/domain/entities/promos.dart';
import 'package:ucookfrontend/features/domain/repositories/promos_repository.dart';

class GetPromosUseCase implements UseCase<List<Promos>, NoParams> {
  final PromosRepository repository;

  GetPromosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Promos>>> call(NoParams params) async {
    return await repository.getPromos();
  }
}