import 'package:idol/models/models.dart';

class LoadHotsAction {}

class HotsNotLoadedAction {
  final String msg;
  HotsNotLoadedAction(this.msg);
}

class HotsLoadedAction {
  final List<Idol> hotIdols;
  final List<Goods> hotGoods;
  final int cart;

  HotsLoadedAction(this.hotIdols, this.hotGoods, this.cart);

  @override
  String toString() {
    return 'HotsLoadedAction{hotIdols: $hotIdols hotGoods: $hotGoods cart: $cart}';
  }
}
