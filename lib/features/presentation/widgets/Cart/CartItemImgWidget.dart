import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/domain/entities/weborderdetail.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';

class CartItemImgWidget extends StatefulWidget {
  CartItemImgWidget({Key? key, required this.detail}) : super(key: key);

  final WebOrderDetail detail;

  @override
  _CartItemImgWidgetState createState() => _CartItemImgWidgetState();
}

class _CartItemImgWidgetState extends State<CartItemImgWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border:
            Border.all(color: ColorHelper().colorFromHex("#989cb8"), width: 2),
      ),
      height: 80,
      width: 80,
      child: Stack(
        children: <Widget>[
          _articleImage('images/appicon.png'),
          //  _imageFrame()
        ],
      ),
    );
  }

  Widget _articleImage(String imagePath) {
    if (imagePath.isEmpty)
      return SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Image(
            image: AssetImage('images/appicon.png'),
          ),
        ),
        height: 400,
        width: 200,
      );
    return SizedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        child: Image(
          image: NetworkImage(
              'https://ucook.alkhazensoft.net/storage/app/' + imagePath),
        ),
      ),
      height: 400,
      width: 200,
    );
  }

  // Widget _imageFrame() {
  //   return Container(
  //     height: 400,
  //     width: 200,
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image: AssetImage('images/art-image-cart.png'),
  //         alignment: Alignment.bottomLeft,
  //       ),
  //     ),
  //   );
  // }
}
