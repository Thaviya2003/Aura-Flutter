import 'api_watch_model.dart';

class CartItemModel {
  final ApiWatchModel watch;
  int quantity;

  CartItemModel({
    required this.watch,
    this.quantity = 1,
  });
}