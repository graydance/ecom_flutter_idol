import 'dart:convert';

class GoodsSkus {
  final String id;
  final int originalPrice;
  final int currentPrice;
  final int earningPrice;
  final String barcode;
  final int stock;
  final int sales;
  final int weight;
  final String skuImage;
  final String skuSpecIds;
  final String goodId;
  final String originalPriceStr;
  final String currentPriceStr;

  const GoodsSkus({
    this.id = '',
    this.originalPrice = 0,
    this.currentPrice = 0,
    this.earningPrice = 0,
    this.barcode = '',
    this.stock = 0,
    this.sales = 0,
    this.weight = 0,
    this.skuImage = '',
    this.skuSpecIds = '',
    this.goodId = '',
    this.originalPriceStr = '',
    this.currentPriceStr = '',
  });

  GoodsSkus copyWith({
    String id,
    int originalPrice,
    int currentPrice,
    int earningPrice,
    String barcode,
    int stock,
    int sales,
    int weight,
    String skuImage,
    String skuSpecIds,
    String goodId,
    String originalPriceStr,
    String currentPriceStr,
  }) {
    return GoodsSkus(
      id: id ?? this.id,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      earningPrice: earningPrice ?? this.earningPrice,
      barcode: barcode ?? this.barcode,
      stock: stock ?? this.stock,
      sales: sales ?? this.sales,
      weight: weight ?? this.weight,
      skuImage: skuImage ?? this.skuImage,
      skuSpecIds: skuSpecIds ?? this.skuSpecIds,
      goodId: goodId ?? this.goodId,
      originalPriceStr: originalPriceStr ?? this.originalPriceStr,
      currentPriceStr: currentPriceStr ?? this.currentPriceStr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalPrice': originalPrice,
      'currentPrice': currentPrice,
      'earningPrice': earningPrice,
      'barcode': barcode,
      'stock': stock,
      'sales': sales,
      'weight': weight,
      'skuImage': skuImage,
      'skuSpecIds': skuSpecIds,
      'goodId': goodId,
      'originalPriceStr': originalPriceStr,
      'currentPriceStr': currentPriceStr,
    };
  }

  factory GoodsSkus.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GoodsSkus(
      id: map['id'],
      originalPrice: map['originalPrice'],
      currentPrice: map['currentPrice'],
      earningPrice: map['earningPrice'],
      barcode: map['barcode'],
      stock: map['stock'],
      sales: map['sales'],
      weight: map['weight'],
      skuImage: map['skuImage'],
      skuSpecIds: map['skuSpecIds'],
      goodId: map['goodId'],
      originalPriceStr: map['originalPriceStr'],
      currentPriceStr: map['currentPriceStr'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsSkus.fromJson(String source) =>
      GoodsSkus.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GoodsSkus &&
        o.id == id &&
        o.originalPrice == originalPrice &&
        o.currentPrice == currentPrice &&
        o.earningPrice == earningPrice &&
        o.barcode == barcode &&
        o.stock == stock &&
        o.sales == sales &&
        o.weight == weight &&
        o.skuImage == skuImage &&
        o.skuSpecIds == skuSpecIds &&
        o.goodId == goodId &&
        o.originalPriceStr == originalPriceStr &&
        o.currentPriceStr == currentPriceStr;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        originalPrice.hashCode ^
        currentPrice.hashCode ^
        earningPrice.hashCode ^
        barcode.hashCode ^
        stock.hashCode ^
        sales.hashCode ^
        weight.hashCode ^
        skuImage.hashCode ^
        skuSpecIds.hashCode ^
        goodId.hashCode ^
        originalPriceStr.hashCode ^
        currentPriceStr.hashCode;
  }

  @override
  String toString() {
    return 'GoodsSkus(id: $id, originalPrice: $originalPrice, currentPrice: $currentPrice, earningPrice: $earningPrice, barcode: $barcode, stock: $stock, sales: $sales, weight: $weight, skuImage: $skuImage, skuSpecIds: $skuSpecIds, goodId: $goodId, originalPriceStr: $originalPriceStr, currentPriceStr: $currentPriceStr)';
  }
}
