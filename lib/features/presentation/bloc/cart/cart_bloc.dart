import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ucookfrontend/features/data/datasources/Cash/cache_cart_data_source.dart';
import 'package:ucookfrontend/features/data/models/web_order_model.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/domain/usecases/order.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  late CartCashDataSourceImpl _cartCashDataSourceImpl;
  final OrderUseCase orderUseCase;
  final String Unknow_ERROR = 'Error in store order';

  CartBloc({
    required OrderUseCase orderUseCase,
  })  : assert(orderUseCase != null),
        this.orderUseCase = orderUseCase,
        super(CartInitial()) {
    add(CartPageInitializedEvent());
  }

  WebOrder webOrder = WebOrder(
      id: 0,
      created_at: '1980-01-01',
      updated_at: '1980-01-01',
      exported: '',
      deliveryAddress: '',
      orderStatus: '0',
      orderType: '0',
      remark: '',
      webOrderDetails: []);

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CartPageInitializedEvent) {
      WebOrder cartData = _cartCashDataSourceImpl.getCart();
      yield CartPageLoadedState(cartData: cartData);
    } else if (event is ItemAddingCartEvent) {
      WebOrderDetail orderDetail = webOrder.webOrderDetails.firstWhere(
          (element) => element.article_id == event.articleId,
          orElse: () => WebOrderDetail(
              unitname: '', article_id: -1, price: 0, quantity: 0));
      if (orderDetail.article_id != -1) {
        orderDetail.quantity++;
      } else {
        orderDetail = WebOrderDetail(
          unitname: event.unitName,
          article_id: event.articleId,
          price: event.unitPrice,
          quantity: 1,
        );
        webOrder.webOrderDetails.add(orderDetail);
      }
      yield ItemAddedCartState(
          quantity: orderDetail.quantity, articleId: orderDetail.article_id);
    } else if (event is ItemDeleteCartEvent) {
      WebOrderDetail orderDetail = webOrder.webOrderDetails.firstWhere(
          (element) => element.article_id == event.articleId,
          orElse: () => WebOrderDetail(
              unitname: '', article_id: -1, price: 0, quantity: 0));
      if (orderDetail.article_id != -1) {
        if (orderDetail.quantity > 0) {
          if (orderDetail.quantity == 1) {
            webOrder.webOrderDetails.removeWhere(
                (element) => element.article_id == event.articleId);
            yield ItemDeletedCartState(
              articleId: event.articleId,
              quantity: 0,
            );
          } else {
            orderDetail.quantity--;
            yield ItemDeletedCartState(
              articleId: event.articleId,
              quantity: orderDetail.quantity,
            );
          }
        }
      }
    } else if (event is AllCartEvent) {
      yield AllCartState(cartItems: webOrder);
    } else if (event is StoreOrderEvent) {
      var w = WebOrderModel(
        id: 0,
        created_at: event.webOrder.created_at,
        updated_at: event.webOrder.updated_at,
        exported: event.webOrder.exported,
        deliveryAddress: event.webOrder.deliveryAddress,
        orderStatus: event.webOrder.orderStatus,
        remark: event.webOrder.remark,
        orderType: event.webOrder.orderType,
        webOrderDetails: event.webOrder.webOrderDetails,
      );
      final res = await orderUseCase.storeOrder(w);
      yield* res.fold((failure) async* {
        yield StoreError(message: Unknow_ERROR);
      }, (webOrder) async* {
        yield StoreOrderState();
      });
    } else if (event is RemoveCartEvent) {
      webOrder = WebOrder(
          id: 0,
          created_at: '1980-01-01',
          updated_at: '1980-01-01',
          exported: '',
          deliveryAddress: '',
          orderStatus: '0',
          orderType: '0',
          remark: '',
          webOrderDetails: []);
      yield RemovedCartState(cartItems: webOrder);
    }
  }
}
