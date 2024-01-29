import 'package:flutter/material.dart';
import 'package:masvel/firebase/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  //void addPlaceToWishlist() {}

  void removeOneItem(String image) {
    _wishlistItems.remove(image);
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
