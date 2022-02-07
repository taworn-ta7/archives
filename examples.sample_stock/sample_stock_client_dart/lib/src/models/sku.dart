import 'package:json_annotation/json_annotation.dart';

part 'sku.g.dart';

@JsonSerializable()
class Sku {
  // id
  int id;

  // link to table users
  String uid;

  // code
  String code;
  String? barcode;

  // cost to buy
  String cost;

  // price to sell
  String price;

  // quantity in stock
  int quantity;

  // image file
  String? image;

  // constructor
  Sku({
    this.id = 0,
    this.uid = '',
    this.code = '',
    this.barcode,
    this.cost = '0.00',
    this.price = '0.00',
    this.quantity = 0,
  });

  // from and to JSON
  factory Sku.fromJson(Map<String, dynamic> json) => _$SkuFromJson(json);
  Map<String, dynamic> toJson() => _$SkuToJson(this);

  @override
  String toString() =>
      '$id, code=$code, barcode=${barcode ?? ''}, cost=$cost, price=$price, qty=$quantity';
}
