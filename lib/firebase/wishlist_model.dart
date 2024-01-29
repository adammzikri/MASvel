import 'package:flutter/material.dart';

class WishlistModel with ChangeNotifier {
  final String image, name, description;

  WishlistModel({
    required this.image,
    required this.name,
    required this.description,
  });
}
