// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';

// class VideoFullScreenPage extends StatefulWidget {
//   final String url;
//   VideoFullScreenPage({required this.url});
//   @override
//   _VideoFullScreenState createState() => _VideoFullScreenState();
// }

// class _VideoFullScreenState extends State<VideoFullScreenPage> {
//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => new AlertDialog(
//             title: new Text(
//                 getLang(context, "video-fullscreen-page-exit-page-title") ??
//                     ''),
//             content: new Text(
//                 getLang(context, "video-fullscreen-page-exit-page-message") ??
//                     ''),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: new Text(getLang(context, "no") ?? ''),
//               ),
//               TextButton(
//                 onPressed: () {
//                   SystemChrome.setPreferredOrientations([
//                     DeviceOrientation.portraitUp,
//                     DeviceOrientation.portraitDown
//                   ]);
//                   Navigator.of(context).pop(true);
//                 },
//                 child: new Text(getLang(context, "yes") ?? ''),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(backgroundColor: Colors.white, body: _buildBody(context)),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     String html = "<html> " +
//         "<body> " +
//         "<div id='content'> " +
//         "<iframe src='https://www.facebook.com/v2.3/plugins/video.php?allowfullscreen=false&autoplay=false&href=${widget.url}'  " +
//         "allowtransparency='true' frameborder='0' scrolling='no'  " +
//         "class='wistia_embed' name='wistia_embed' allowfullscreen  " +
//         "mozallowfullscreen webkitallowfullscreen oallowfullscreen  " +
//         "msallowfullscreen></iframe> " +
//         "</div> " +
//         "</body> " +
//         "<style> " +
//         "body, html { " +
//         "margin: 0; " +
//         "padding: 0; " +
//         "height: 100%; " +
//         "overflow: hidden; " +
//         "} " +
//         "#content { " +
//         "position:absolute; " +
//         "left: 0; " +
//         "right: 0; " +
//         "bottom: 0; " +
//         "top: 0 " +
//         "} " +
//         "body { " +
//         "display: block; " +
//         "width: 100vh; " +
//         "height: 100vw; " +
//         "border: none; " +
//         "transform: translateY(100vh) rotate(-90deg); " +
//         "transform-origin: top left; " +
//         "} " +
//         "</style> " +
//         "</html>";
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       child: Center(
//         child: HtmlWidget(
//           html,
//           webView: true,
//         ),
//       ),
//     );
//   }
// }
