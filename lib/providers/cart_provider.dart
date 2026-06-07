import 'package:flutter/material.dart';
import '../models/api_watch_model.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  void addToCart(ApiWatchModel watch) {
    final index = _cartItems.indexWhere((item) => item.watch.id == watch.id);

    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItemModel(watch: watch));
    }

    notifyListeners();
  }

  void removeFromCart(ApiWatchModel watch) {
    _cartItems.removeWhere((item) => item.watch.id == watch.id);

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.watch.price * item.quantity),
    );
  }
}
