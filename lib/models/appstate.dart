import 'package:idol/models/models.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final String hotLoadError;
  final List<Idol> hotIdols;
  final List<Goods> hotGoods;
  final int cart;

  AppState(
      {this.isLoading = false,
      this.hotLoadError = '',
      this.hotIdols = const [],
      this.hotGoods = const [],
      this.cart = 0});

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith(
      {bool isLoading,
      String hotLoadError,
      List<Idol> hotIdols,
      List<Goods> hotGoods,
      int cart}) {
    return AppState(
        isLoading: isLoading ?? this.isLoading,
        hotLoadError: hotLoadError ?? this.hotLoadError,
        hotIdols: hotIdols ?? this.hotIdols,
        hotGoods: hotGoods ?? this.hotGoods,
        cart: cart ?? this.cart);
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      hotLoadError.hashCode ^
      hotIdols.hashCode ^
      hotGoods.hashCode ^
      cart.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          hotLoadError == other.hotLoadError &&
          hotIdols == other.hotIdols &&
          hotGoods == other.hotGoods &&
          cart == other.cart;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, hotLoadError:$hotLoadError hotIdols: $hotIdols hotGoods:$hotGoods cart:$cart}';
  }
}
