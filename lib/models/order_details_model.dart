import 'address_model.dart';

class OrdersDetailsModel {
  bool? status;
  String? message;
  Data? data;


  OrdersDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

}

class Data {
  int? id;
  double? cost;
  double? discount;
  double? points;
  double? vat;
  double? total;
  int? pointsCommission;
  String? promoCode;
  String? paymentMethod;
  String? date;
  String? status;
  DataAddress? address;
  List<Products>? products;



  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'].toDouble();
    discount = json['discount'].toDouble();
    points = json['points'].toDouble();
    vat = json['vat'].toDouble();
    total = json['total'].toDouble();
    pointsCommission = json['points_commission'];
    promoCode = json['promo_code'];
    paymentMethod = json['payment_method'];
    date = json['date'];
    status = json['status'];
    address =
    json['address'] != null ? DataAddress.fromJson(json['address']) : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

}


class Products {
  int? id;
  int? quantity;
  int? price;
  String? name;
  String? image;


  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    name = json['name'];
    image = json['image'];
  }

}
