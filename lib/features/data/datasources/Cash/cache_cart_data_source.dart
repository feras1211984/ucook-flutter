import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucookfrontend/features/data/models/web_order_model.dart';

abstract class CartCashDataSource {
  void saveCart(WebOrderModel cart);
  WebOrderModel getCart();
}

class CartCashDataSourceImpl implements CartCashDataSource {
  final SharedPreferences sharedPreferences;
  CartCashDataSourceImpl(this.sharedPreferences);

  @override
  WebOrderModel getCart() {
    String? tmp = sharedPreferences.getString('cart');
    if (tmp == null)
      return new WebOrderModel(
          id: 0,
          created_at: '1980-01-01',
          updated_at: '1980-01-01',
          exported: '',
          webOrderDetails: [],
          deliveryAddress: '',
          orderStatus: '0',
          remark: '',
          orderType: '');
    Map<String, dynamic> cartMap = jsonDecode(tmp as String);
    WebOrderModel cart = WebOrderModel.fromJson(cartMap);
    if (cart == null)
      return new WebOrderModel(
          id: 0,
          created_at: '1980-01-01',
          updated_at: '1980-01-01',
          exported: '',
          webOrderDetails: [],
          deliveryAddress: '',
          orderStatus: '0',
          remark: '',
          orderType: '');
    else
      return cart;
  }

  @override
  void saveCart(WebOrderModel cart) {
    sharedPreferences.setString('cart', jsonEncode(cart.toJson()));
  }
}
