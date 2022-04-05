import 'package:flutter/material.dart';

class ItemDetailDescription extends StatefulWidget {
  @override
  _ItemDetailDescriptionState createState() => _ItemDetailDescriptionState();
}

class _ItemDetailDescriptionState extends State<ItemDetailDescription> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 320,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
