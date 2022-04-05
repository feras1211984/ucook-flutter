import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CarouselVideoWidget extends StatefulWidget {
  final String link;

  CarouselVideoWidget({Key? key, required this.link}) : super(key: key);

  @override
  _CarouselVideoWidgetState createState() => _CarouselVideoWidgetState();
}

class _CarouselVideoWidgetState extends State<CarouselVideoWidget> {
  late YoutubePlayerController youtubeController;
  late bool isYoutube;

  _CarouselVideoWidgetState();

  @override
  void initState() {
    super.initState();
    if (this.widget.link.contains('youtu.be')) {
      isYoutube = true;
      initializeYoutubeVideoPlayer(this.widget.link);
    } else {
      isYoutube = false;
    }
  }

  @override
  void dispose() {
    if (this.widget.link.contains('youtu.be')) {
      youtubeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (isYoutube) {
    return Container(
      child: Center(
        child: YoutubePlayer(
          controller: youtubeController,
          bottomActions: [
            const SizedBox(width: 14.0),
            CurrentPosition(),
            const SizedBox(width: 8.0),
            ProgressBar(
              isExpanded: true,
            ),
            RemainingDuration(),
            const PlaybackSpeedButton(),
          ],
        ),
      ),
    );
    // }
    // else {
    //   return GestureDetector(
    //     onTap: () {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) => _buildPopupDialog(
    //                 context,
    //               ));
    //     },
    //     child: Container(
    //       child: Stack(
    //         children: <Widget>[
    //           Center(
    //             child: Image.asset(
    //               'images/logo@2x.png',
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //           Positioned(
    //             bottom: 0,
    //             child: Text(
    //               getLang(context, "carousel-video-widget-click") ?? '',
    //               style: TextStyle(
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }

  Future<void> initializeYoutubeVideoPlayer(String videoUrl) async {
    String s = videoUrl;
    var pos = s.lastIndexOf('/');
    String result = (pos != -1) ? s.substring(pos, s.length) : s;
    youtubeController = YoutubePlayerController(
      initialVideoId: result,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        disableDragSeek: true,
        mute: false,
        loop: false,
        isLive: false,
        forceHD: false,
      ),
    );
  }

  // Widget _buildPopupDialog(BuildContext context) {
  //   return Dialog(
  //     insetPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
  //     backgroundColor: Colors.transparent,
  //     child: Container(
  //       width: MediaQuery.of(context).size.width * 0.9,
  //       height: MediaQuery.of(context).size.height * 0.3,
  //       decoration: BoxDecoration(
  //         color: ColorHelper().colorFromHex("#354449"),
  //       ),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 GestureDetector(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Icon(
  //                       Icons.close,
  //                       color: Colors.grey,
  //                     )),
  //               ],
  //             ),
  //           ),
  //           Center(
  //             child: HtmlWidget(
  //               "<iframe width='200' height='105' src='https://www.facebook.com/v2.3/plugins/video.php?allowfullscreen=false&autoplay=false&href=${widget.link}'> </iframe>",
  //               webView: true,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
