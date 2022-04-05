import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/domain/entities/promos.dart';
import 'package:ucookfrontend/features/presentation/bloc/carousel/carousel_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/carousel/carousel_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/carousel/carousel_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/carousel_video_widget.dart';
import '../../../injection_container.dart';

class CarouselWidget extends StatefulWidget {
  CarouselWidget();

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  String name = "";
  int position = 0;
  List<Promos> promotions = [];

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget _shimmerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    (0.toString() + '/' + 0.toString()).toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: SharedController().colorFromHex("#354449"),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Bahnschrift",
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Promos Name',
                    style: TextStyle(
                      fontSize: 14,
                      color: SharedController().colorFromHex("#354449"),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Bahnschrift",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              height: MediaQuery.of(context).size.height / 5,
              onPageChanged: (index, reason) {
                setState(() {
                  position = index + 1;
                  name = promotions[index].title.toString();
                });
              },
            ),
            items: [
              for (var i = 0; i < 2; i++)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: SharedController().colorFromHex("#989cb8")),
                  child: imageOrVideo(
                    new Promos(
                        image: '', title: '', link: '', body: '', type: ''),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  BlocProvider<CarouselBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CarouselBloc>(),
      child: BlocConsumer<CarouselBloc, CarouselState>(
        listener: (context, state) {
          if (state is Loaded) {
            this.promotions = state.promos;
            this.position = 1;
            this.name = promotions[0].title.toString();
          }
        },
        builder: (context, state) {
          if (state is Empty) {
            BlocProvider.of<CarouselBloc>(context).add(GetCarouselItem());
          } else if (state is Loaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            (promotions.length.toString() +
                                    '/' +
                                    position.toString())
                                .toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: SharedController().colorFromHex("#354449"),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Bahnschrift",
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              color: SharedController().colorFromHex("#354449"),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Bahnschrift",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      height: MediaQuery.of(context).size.height / 5,
                      onPageChanged: (index, reason) {
                        setState(() {
                          position = index + 1;
                          name = promotions[index].title.toString();
                        });
                      },
                    ),
                    items: [
                      for (var i = 0; i < promotions.length; i++)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: ColorHelper().colorFromHex("#989cb8")),
                          child: imageOrVideo(
                            promotions[i],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            );
          }
          return _shimmerWidget();
        },
      ),
    );
  }

  Widget imageOrVideo(Promos promos) {
    var link;
    if (promos.type == "youtube") {
      if (promos.link.contains(RegExp(r'youtube.com'))) {
        link = 'https://youtu.be/' +
            promos.link.substring(promos.link.indexOf(RegExp(r'=')) + 1);
      } else {
        link = promos.link;
      }
      return CarouselVideoWidget(link: link);
    } else if (promos.type == '') {
      return Image.asset(
        'images/logo@2x.png',
        fit: BoxFit.fill,
      );
    } else {
      var image = promos.image.replaceAll(RegExp(r'storage'), 'public');
      return Image.network(
        image,
        fit: BoxFit.fill,
      );
    }
  }

  Widget createSingleItem(Widget child) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: child,
    );
  }
}
