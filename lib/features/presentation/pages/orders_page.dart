import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/weborder.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/presentation/bloc/order/order_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/order/order_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/order/order_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/number_display.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/custom_expansion_panel_list.dart';
import 'package:ucookfrontend/features/presentation/widgets/loading_widget.dart';
import 'package:ucookfrontend/injection_container.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<WebOrder> orders = [];

  double totalAmount = 0.0;
  void calculateTotalAmount(List<WebOrderDetail> list) {
    double res = 0;

    list.forEach((element) {
      res = res + element.price * element.quantity;
    });
    totalAmount = res;
  }

  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  BlocProvider<OrderBloc> _buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<OrderBloc>(),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderPageInitial) {
              BlocProvider.of<OrderBloc>(context)
                  .add(OrderPageInitializedEvent());
              return LoadingWidget(
                withScaffold: false,
              );
            } else if (state is OrderPageLoadedState) {
              BlocProvider.of<OrderBloc>(context).isFetching = false;
              orders = state.orders
                  .where((element) =>
                      SharedController().daysBetween(
                          DateTime.parse(element.created_at), DateTime.now()) <
                      10)
                  .toList();
              return _loadedData(context);
            } else if (state is Loading) {
              return CircularProgressIndicator();
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Widget _loadedData(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomExpansionPanelList(
            animationDuration: Duration(milliseconds: 1000),
            dividerColor: ColorHelper().colorFromHex('#989cb8'),
            children: [
              CustomExpansionPanel(
                kPanelHeaderCollapsedHeight:
                    SharedController().scaledHeight(context, 35),
                kPanelHeaderExpandedHeight:
                    SharedController().scaledHeight(context, 35),
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        orderDateAndId(index),
                        orderCost(index),
                      ],
                    ),
                  );
                },
                body: Container(
                  padding:
                      EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: orders[index].webOrderDetails.map((order) {
                      return orderDetails(order);
                    }).toList(),
                  ),
                ),
                isExpanded: orders[index].expanded,
              )
            ],
            expansionCallback: (int item, bool status) {
              setState(() {
                orders[index].expanded = !orders[index].expanded;
              });
            },
          );
        },
      ),
    );
  }

  Widget orderCost(int index) {
    final display = createDisplay();
    calculateTotalAmount(orders[index].webOrderDetails);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              display(totalAmount) + '  ' + 'SP',
              style: TextStyle(
                color: ColorHelper().colorFromHex('#354449'),
                fontSize: SharedController().getAdaptiveTextSize(context, 22),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget orderDateAndId(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (getLang(context, "orders-page-order-id") ?? '') +
                  orders[index].id.toString(),
              style: TextStyle(
                color: ColorHelper().colorFromHex('#354449'),
                fontSize: SharedController().getAdaptiveTextSize(context, 14),
              ),
            ),
            // Text(
            //   (getLang(context, "orders-page-order-status") ?? '') +
            //       (orders[index].orderStatus == '0'
            //           ? getLang(
            //                   context, "orders-page-order-processing-orders") ??
            //               ''
            //           : getLang(context, "orders-page-order-done-orders") ??
            //               ''),
            //   style: TextStyle(
            //     color: ColorHelper().colorFromHex('#354449'),
            //     fontSize: 14,
            //   ),
            // ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              orders[index].created_at.split('T')[0],
              style: TextStyle(
                color: ColorHelper().colorFromHex('#354449'),
                fontSize: SharedController().getAdaptiveTextSize(context, 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget orderDetails(WebOrderDetail x) {
    final display = createDisplay();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              x.quantity.toString() + '× ' + x.unitname,
              style: TextStyle(
                  color: ColorHelper().colorFromHex('#989cb8'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 18),
                  letterSpacing: 0.3,
                  height: 1.3),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              display(x.price) + '  ' + 'SP',
              style: TextStyle(
                  color: ColorHelper().colorFromHex('#989cb8'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 16),
                  letterSpacing: 0.3,
                  height: 1.3),
            ),
          ],
        ),
      ],
    );
  }

  Widget cartTotal(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              'مجموع السلة',
              style: TextStyle(
                  color: ColorHelper().colorFromHex('#354449'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 12),
                  letterSpacing: 0.3,
                  height: 1.3),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '100',
              style: TextStyle(
                  color: ColorHelper().colorFromHex('#354449'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 12),
                  letterSpacing: 0.3,
                  height: 1.3),
            ),
          ],
        ),
      ],
    );
  }

  Widget total(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              getLang(context, "orders-page-total") ?? '',
              style: TextStyle(
                  color: ColorHelper().colorFromHex('#354449'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 12),
                  letterSpacing: 0.3,
                  height: 1.3),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              totalAmount.toString(),
              style: TextStyle(
                  color: ColorHelper().colorFromHex('#354449'),
                  fontSize: SharedController().getAdaptiveTextSize(context, 12),
                  letterSpacing: 0.3,
                  height: 1.3),
            ),
          ],
        ),
      ],
    );
  }
}
