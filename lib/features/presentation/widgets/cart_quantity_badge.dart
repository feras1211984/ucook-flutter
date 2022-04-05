import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_state.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

class CartQuantityBadge extends StatelessWidget {
  const CartQuantityBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        var quantity = 0;
        if (state is ItemDeletedCartState) {
          quantity = BlocProvider.of<CartBloc>(context)
              .webOrder
              .webOrderDetails
              .length
              .toInt();
        } else if (state is ItemAddedCartState) {
          quantity = BlocProvider.of<CartBloc>(context)
              .webOrder
              .webOrderDetails
              .length
              .toInt();
        } else if (state is AllCartState) {
          quantity = BlocProvider.of<CartBloc>(context)
              .webOrder
              .webOrderDetails
              .length
              .toInt();
        }
        return Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: SharedController().getAdaptiveTextSize(context, 15),
            fontFamily: "Bahnschrift",
          ),
        );
      },
    );
  }
}
