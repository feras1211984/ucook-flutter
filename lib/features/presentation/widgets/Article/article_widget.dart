import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/domain/entities/article.dart';

class ArticleCardWidget extends StatefulWidget {
  const ArticleCardWidget(
      {Key? key,
      required this.article,
      required this.addToCart,
      required this.press})
      : super(key: key);
  final Article article;
  final Function press;
  final Function addToCart;

  @override
  _ArticleCardWidgetState createState() => _ArticleCardWidgetState();
}

class _ArticleCardWidgetState extends State<ArticleCardWidget> {
  // @override
  // Widget build(BuildContext context) {
  //   print("ArticleCardWidget"+MediaQuery.of(context).size.height.toString());
  //   return Center(
  //       child: Container(
  //    height: MediaQuery.of(context).size.width * 0.5,
  //     width: MediaQuery.of(context).size.width * 0.5,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.only(left: 10, right: 10),
  //           child: ArticleImgWidget(
  //             article: widget.article,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              height: 240,
              width: 156,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 30),
                      blurRadius: 60,
                      color: Color(0xFF393939).withOpacity(.1))
                ],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(),
                    ),
                  ],
                ),
              ),
              // ),
            ),
            Positioned(
                top: 0,
                child: Image.asset(
                  'assets/images/shape1.png',
                  height: 99,
                )),
            Positioned(
                bottom: 25,
                right: -1,
                child: Image.asset(
                  'assets/images/shape2.png',
                  height: 66,
                )),
            Positioned(
              top: 30,
              right: 5,
              child: Image.network(
                this.widget.article.image,
                height: 80,
              ),
            ),
            Positioned(
              bottom: 70,
              right: 20,
              child: FlatButton(
                  color: Color(0xFF845EC2),
                  onPressed: () {},
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Positioned(
              top: 30,
              right: 5,
              child: Image.network(
                this.widget.article.image,
                height: 80,
              ),
            ),
            Positioned(
              top: 110,
              right: 50,
              child: Text(
                this.widget.article.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 130,
              right: 50,
              child: Text(
                '\$ ${this.widget.article.unit1price}',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
