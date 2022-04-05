import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/number_display.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/Cart/CartItemWidget.dart';
import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';

class CartPage extends StatefulWidget {
  CartPage({
    Key? key,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context).add(AllCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: Colors.white,
          drawer: DrawerWidget(),
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(SharedController().scaledHeight(context, 60)),
            child: CustomAppBar(
              showSearch: true,
              showCart: false,
              showBackButton: true,
            ),
          ),
          body: _buildBody(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _cartActionsButtons()),
    );
  }

  Future<bool> _onWillPop() async {
    BlocProvider.of<CartBloc>(context).add(AllCartEvent());
    return true;
  }

  double totalAmount = 0.0;
  void calculateTotalAmount(List<WebOrderDetail> list) {
    double res = 0;

    list.forEach((element) {
      res = res + element.price * element.quantity;
    });
    totalAmount = res;
  }

  _cartActionsButtons() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 30,
          bottom: 5,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.height / 15,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: 'clearCart',
                onPressed: BlocProvider.of<CartBloc>(context)
                            .webOrder
                            .webOrderDetails
                            .length <=
                        0
                    ? null
                    : () {
                        showConfirmRemoveCartDialog(context);
                      },
                backgroundColor: ColorHelper().colorFromHex('#354449'),
                child: Icon(
                  Icons.remove_shopping_cart,
                  color: Colors.white,
                  size: SharedController().getAdaptiveTextSize(context, 20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 30,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.width / 2,
            child: FloatingActionButton.extended(
              heroTag: 'sendOrder',
              onPressed: BlocProvider.of<CartBloc>(context)
                          .webOrder
                          .webOrderDetails
                          .length <=
                      0
                  ? null
                  : () {
                      showConfirmOrderDialog(context);
                    },
              backgroundColor: ColorHelper().colorFromHex('#354449'),
              disabledElevation: 0,
              label: Text(
                getLang(context, "cart-widget-send-order-btn") ?? '',
                style: TextStyle(
                    fontSize:
                        SharedController().getAdaptiveTextSize(context, 22),
                    fontFamily: "Bahnschrift",
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              icon: Icon(
                Icons.payment,
                color: Colors.white,
                size: SharedController().getAdaptiveTextSize(context, 22),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(right: 15, left: 15),
          //   child: Text(
          //     getLang(context, "cart-widget-title") ?? '',
          //     style: Theme.of(context).textTheme.headline6,
          //     softWrap: true,
          //   ),
          // ),
          _cartItems(),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, bottom: 1.5),
            child: Divider(
              height: 15,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: _totalText(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cartItems() {
    double height = MediaQuery.of(context).size.height / 1.44;
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is AllCartState) {
        return Container(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (var x in state.cartItems.webOrderDetails)
                  CartItemWidget(detail: x),
                if (state.cartItems.webOrderDetails.length == 0)
                  _emptyCartBody()
              ],
            ),
          ),
        );
      } else if (state is ItemAddedCartState || state is ItemDeletedCartState) {
        return Container(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (var x in BlocProvider.of<CartBloc>(context)
                    .webOrder
                    .webOrderDetails)
                  CartItemWidget(detail: x),
                if (BlocProvider.of<CartBloc>(context)
                        .webOrder
                        .webOrderDetails
                        .length ==
                    0)
                  _emptyCartBody()
              ],
            ),
          ),
        );
      } else if (state is StoreOrderState) {
        BlocProvider.of<CartBloc>(context).webOrder = WebOrder(
            id: 0,
            created_at: '1980-01-01',
            updated_at: '1980-01-01',
            exported: '',
            deliveryAddress: '',
            orderStatus: '0',
            orderType: '0',
            remark: '',
            webOrderDetails: []);
      } else if (state is RemovedCartState) return _emptyCart();

      return _emptyCart();
    });
  }

  Widget _emptyCart() {
    double height = MediaQuery.of(context).size.height * 0.65;
    return Container(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[_emptyCartBody()],
        ),
      ),
    );
  }

  Widget _emptyCartBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Text(
          getLang(context, "cart-widget-empty-cart") ?? '',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }

  Widget _totalText() {
    final display = createDisplay();
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      calculateTotalAmount(
          BlocProvider.of<CartBloc>(context).webOrder.webOrderDetails);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getLang(context, "cart-widget-total") ?? '',
                style: TextStyle(
                    fontSize:
                        SharedController().getAdaptiveTextSize(context, 20),
                    fontFamily: "Bahnschrift",
                    fontWeight: FontWeight.w500,
                    color: ColorHelper().colorFromHex("#354449")),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${display(totalAmount)} S.P.',
                style: TextStyle(
                    fontSize:
                        SharedController().getAdaptiveTextSize(context, 20),
                    fontFamily: "Bahnschrift",
                    fontWeight: FontWeight.w500,
                    color: ColorHelper().colorFromHex("#354449")),
              )
            ],
          ),
        ],
      );
    });
  }

  showConfirmOrderDialog(BuildContext context) {
    // set up the buttons
    Widget paidShippingButton = TextButton(
      child: Text(getLang(context, "cart-page-paid-shipping") ?? ''),
      onPressed: () {
        BlocProvider.of<CartBloc>(context).webOrder.remark += '- شحن مأجور -';
        BlocProvider.of<CartBloc>(context).add(StoreOrderEvent(
            webOrder: BlocProvider.of<CartBloc>(context).webOrder));
        Navigator.of(context).pop();
      },
    );
    Widget receiptFromHButton = TextButton(
      child: Text(getLang(context, "cart-page-receipt-from-the-hall") ?? ''),
      onPressed: () {
        BlocProvider.of<CartBloc>(context).webOrder.remark +=
            '- استلام من الصالة -';
        BlocProvider.of<CartBloc>(context).add(StoreOrderEvent(
            webOrder: BlocProvider.of<CartBloc>(context).webOrder));
        Navigator.of(context).pop();
      },
    );
    Widget backButton = TextButton(
      child: Text(getLang(context, "back") ?? ''),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(getLang(context, "cart-page-confirm-order-title") ?? ''),
      content: Text(getLang(context, "cart-page-confirm-order-msg") ?? ''),
      actions: [
        paidShippingButton,
        receiptFromHButton,
        backButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showConfirmRemoveCartDialog(BuildContext context) {
    Widget backButton = TextButton(
      child: Text(getLang(context, "back") ?? ''),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget removeCartButton = TextButton(
      child: Text(getLang(context, "cart-page-remove-cart-btn") ?? ''),
      onPressed: () {
        BlocProvider.of<CartBloc>(context).add(RemoveCartEvent());
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title:
          Text(getLang(context, "cart-page-confirm-remove-cart-title") ?? ''),
      content:
          Text(getLang(context, "cart-page-confirm-remove-cart-msg") ?? ''),
      actions: [
        backButton,
        removeCartButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
