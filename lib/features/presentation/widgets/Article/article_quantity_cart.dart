import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_state.dart';
import 'package:ucookfrontend/features/presentation/utils/responsive_flutter_pkg/responsive_flutter.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

class ArticleQuantityCart extends StatefulWidget {
  final int number;
  final int articleId;
  final Color color;

  const ArticleQuantityCart(
      {Key? key,
      required this.number,
      required this.articleId,
      required this.color})
      : super(key: key);

  @override
  _ArticleQuantityCartState createState() => _ArticleQuantityCartState();
}

class _ArticleQuantityCartState extends State<ArticleQuantityCart> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        var newQuantity = widget.number;
        if (state is ItemAddedCartState) {
          if (state.articleId == widget.articleId) {
            newQuantity = state.quantity;
          } else {
            newQuantity = BlocProvider.of<CartBloc>(context)
                .webOrder
                .webOrderDetails
                .firstWhere((element) => element.article_id == widget.articleId,
                    orElse: () => WebOrderDetail(
                        unitname: '', article_id: -1, price: 0, quantity: 0))
                .quantity;
          }
        } else if (state is ItemDeletedCartState) {
          if (state.articleId == widget.articleId) {
            newQuantity = state.quantity;
          } else {
            newQuantity = BlocProvider.of<CartBloc>(context)
                .webOrder
                .webOrderDetails
                .firstWhere((element) => element.article_id == widget.articleId,
                    orElse: () => WebOrderDetail(
                        unitname: '', article_id: -1, price: 0, quantity: 0))
                .quantity;
          }
        } else if (state is AllCartState) {
          newQuantity = BlocProvider.of<CartBloc>(context)
              .webOrder
              .webOrderDetails
              .firstWhere((element) => element.article_id == widget.articleId,
                  orElse: () => WebOrderDetail(
                      unitname: '', article_id: -1, price: 0, quantity: 0))
              .quantity;
        }
        return Text(
          newQuantity.toString(),
          style: TextStyle(
              fontSize: SharedController().getAdaptiveTextSize(context, 24),
              fontWeight: FontWeight.w500,
              fontFamily: "Bahnschrift",
              color: widget.color),
        );
      },
    );
  }
}
