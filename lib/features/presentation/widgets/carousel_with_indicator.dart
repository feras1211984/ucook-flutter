import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ucookfrontend/features/domain/entities/article_media.dart';
import 'package:ucookfrontend/features/presentation/widgets/carousel_video_widget.dart';

class CarouselWithIndicator extends StatefulWidget {
  final List<ArticleMedia> itemList;
  CarouselWithIndicator({required this.itemList});
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

List<Widget> itemsSliders = [];

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (widget.itemList.length == 0)
      return Container(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  _imageOrLogo(''),
                ],
              )),
        ),
      );
    itemsSliders = widget.itemList.map((item) {
      if (item.type == 'image') {
        return Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    _imageOrLogo(item.link),
                  ],
                )),
          ),
        );
      } else {
        var link;
        if (item.link.contains(RegExp(r'youtube.com'))) {
          link = 'https://youtu.be/' +
              item.link.substring(item.link.indexOf(RegExp(r'=')) + 1);
        } else {
          link = item.link;
        }
        return Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    CarouselVideoWidget(link: link),
                  ],
                )),
          ),
        );
      }
    }).toList();
    return Column(children: [
      CarouselSlider(
        items: itemsSliders,
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.itemList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  Widget _imageOrLogo(String url) {
    return url == ''
        ? Center(
            child: Image.asset(
              'images/appicon.png',
              fit: BoxFit.fill,
            ),
          )
        : Image.network(url, fit: BoxFit.fill, width: 1000.0);
  }
}
