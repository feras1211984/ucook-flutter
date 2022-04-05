// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:ucookfrontend/features/presentation/pages/video_fullscreen_page.dart';
// import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
// import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
// import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
// import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
// import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';

// class CouresesPage extends StatefulWidget {
//   late String url =
//       'https://www.facebook.com/100053943311635/videos/878063349488525';
//   late bool canPlayVideo = true;
//   @override
//   _CoursesState createState() => _CoursesState();
// }

// class _CoursesState extends State<CouresesPage> {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       drawer: DrawerWidget(),
//       appBar: PreferredSize(
//         preferredSize:
//             Size.fromHeight(SharedController().scaledHeight(context, 60)),
//         child: CustomAppBar(
//           showSearch: true,
//           showCart: false,
//         ),
//       ),
//       body: SingleChildScrollView(child: _buildBody(context)),
//     );
//   }

//   Widget _buildBody(context) {
//     return Container(
//         padding: const EdgeInsets.all(16.0),
//         margin: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: ColorHelper().colorFromHex('#989cb8'),
//           ),
//           borderRadius: BorderRadius.all(
//             Radius.circular(17),
//           ),
//         ),
//         child: Column(
//           children: [
//             _videoRow(),
//             _titleAndFullscreenRow(),
//           ],
//         ));
//   }

//   Widget _videoRow() {
//     return Row(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width - 68,
//           height: 200,
//           child: Center(
//             child: HtmlWidget(
//               "<iframe src='https://www.facebook.com/v2.3/plugins/video.php?allowfullscreen=false&autoplay=false&href=${widget.url}'> </iframe>",
//               webView: true,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _titleAndFullscreenRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'title',
//           style: Theme.of(context).textTheme.bodyText2,
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => VideoFullScreenPage(url: widget.url)),
//             );
//           },
//           child: Text(
//             getLang(context, 'courses-page-fullscreen-button'),
//             style: Theme.of(context).textTheme.subtitle2,
//           ),
//         )
//       ],
//     );
//   }
// }
