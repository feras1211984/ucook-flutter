
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/core/error/failures.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/usecases/order.dart';
import 'package:ucookfrontend/features/presentation/bloc/order/order_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/order/order_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderUseCase orderUseCase;
  final String Unknow_ERROR = 'Error in get orders';

  OrderBloc({
    required OrderUseCase orderUseCase,
  })  : assert(orderUseCase != null),
        this.orderUseCase = orderUseCase,
        super(OrderPageInitial()) {
    add(OrderPageInitializedEvent());
  }
  bool isFetching = false;
  int page = 1;
  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    // if (event is OrderPageInitializedEvent) {
    //   yield Loading();
    //   var res = await orderUseCase.getAllOrders(page);
    //   yield* _eitherLoadedOrErrorState(res);
    //   page++;
    //   // yield* res.fold((failure) async* {
    //   //   yield GetOrdersError(message: Unknow_ERROR);
    //   // }, (webOrders) async* {
    //   //   yield OrderPageLoadedState(orders: webOrders);
    //   // });
    // }
    // if (event is OrderFetchEvent) {
    //   final failureOrArticles = await orderUseCase.getAllOrders(page);
    //   yield* _eitherLoadedOrErrorState(failureOrArticles);
    //   page++;
    // }

    if (event is OrderPageInitializedEvent) {
      final failureOrOrders = await orderUseCase.getAllOrders(page);
      yield* _eitherLoadedOrErrorState(failureOrOrders);
      page++;
    }
    if (event is OrderFetchEvent) {
      yield Loading();
      final failureOrOrders = await orderUseCase.getAllOrders(page);
      yield failureOrOrders.fold(
        (failure) => GetOrdersError(message: _mapFailureToMessage(failure)),
        (orders) => FetchingOrdersSuccessState(orders: orders),
      );
      page++;
    }
  }
}

Stream<OrderState> _eitherLoadedOrErrorState(
  Either<Failure, List<WebOrder>> failureOrOrders,
) async* {
  yield failureOrOrders.fold(
    (failure) => GetOrdersError(message: _mapFailureToMessage(failure)),
    (orders) => OrderPageLoadedState(orders: orders),
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
