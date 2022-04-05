import 'package:flutter/material.dart';
import '../../../shared_variables_and_methods.dart';
import '../utils/localiztion/applocal.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NotificationPage extends StatelessWidget {
  final notification;

  const NotificationPage(this.notification);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
        title: Text(
          getLang(context, 'notification-page-title'),
          style: const TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            notification.imageUrl != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: FadeInImage(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                      placeholderFit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      placeholder: const AssetImage(
                        "images/loading.gif",
                      ),
                      image: CachedNetworkImageProvider(
                        notification.imageUrl,
                      ),
                      imageErrorBuilder: (_, __, ___) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "images/notification.png",
                          height: MediaQuery.of(context).size.height * 0.5 - 20,
                          width: MediaQuery.of(context).size.width - 20,
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: ListTile(
                title: Text(
                  notification.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  dateFormatter.format(
                    notification.time,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey,
                  ),
                  left: BorderSide(
                    color: Colors.grey,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  notification.details,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
