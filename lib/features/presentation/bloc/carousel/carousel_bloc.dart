import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/core/usecases/usecase.dart';
import 'package:ucookfrontend/core/util/input_converter.dart';
import 'package:ucookfrontend/features/domain/entities/promos.dart';
import 'package:ucookfrontend/features/domain/usecases/get_promos.dart';
import 'package:ucookfrontend/features/presentation/bloc/carousel/carousel_event.dart';

import '../Constant.dart';
import 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent,CarouselState>
{
  final GetPromosUseCase getCarouselItems;
  final InputConverter inputConverter;
  CarouselBloc({
   required GetPromosUseCase getPromosUseCase,
    required this.inputConverter,
  }) : getCarouselItems = getPromosUseCase,
        super(Empty());

  @override
  Stream<CarouselState> mapEventToState(CarouselEvent event) async* {
    if (event is GetCarouselItem) {
      yield Loading();
       final failureCarousel = await getCarouselItems(NoParams());
       yield* _eitherLoadedOrErrorState(failureCarousel);
    }
  }
  Stream<CarouselState> _eitherLoadedOrErrorState(
      Either<Failure, List<Promos>> failureOrPromos,
      ) async* {
    yield failureOrPromos.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (promoses) => Loaded(promos: promoses),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

}