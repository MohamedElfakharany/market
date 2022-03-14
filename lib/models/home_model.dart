// class HomeModel {
//   var status = false;
//   HomeDataModel data;
//
//   HomeModel.fromJSON(Map<String, dynamic> json) {
//     status = json['status'];
//     data = HomeDataModel.fromJSON(json['data']);
//   }
// }
//
// class HomeDataModel {
//   List<BannersModel> banners = [];
//   List<ProductsModel> products = [];
//
//   HomeDataModel.fromJSON(Map<String, dynamic> json) {
//     json['banners'].forEach((element) {
//       banners.add(element);
//     });
//     json['products'].forEach((element) {
//       products.add(element);
//     });
//   }
// }
//
// class BannersModel {
//   int id;
//   String image;
//   BannersModel.fromJSON(Map<String, dynamic> json) {
//     id = json['id'];
//     image = json['image'];
//   }
// }
//
// class ProductsModel {
//   int id;
//   dynamic price;
//   dynamic oldPrice;
//   dynamic discount;
//   String image;
//   String name;
//   bool inFavorites;
//   bool inCart;
//
//   ProductsModel.fromJSON(Map<String, dynamic> json) {
//     id = json['id'];
//     price = json['price'];
//     oldPrice = json['old_price'];
//     discount = json['discount'];
//     image = json['image'];
//     name = json['name'];
//     inFavorites = json['in_favorites'];
//     inCart = json['in_cart'];
//   }
// }
// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);
///////////////////////////////////////////////////////////////////////////////////////////////////
import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  HomeModel({
    this.status,
    this.data,
  });

  bool status;
  Data data;

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.banners,
    this.products,
  });

  List<BannersModel> banners;
  List<ProductsModel> products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        banners:
            List<BannersModel>.from(json["banners"].map((x) => BannersModel.fromJson(x))),
        products: List<ProductsModel>.from(
            json["products"].map((x) => ProductsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class BannersModel {
  BannersModel({
    this.id,
    this.image,
  });

  int id;
  String image;

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
class ProductsModel {
  ProductsModel({
    this.id,
    this.price,
    this.oldPrice,
    this.discount,
    this.image,
    this.name,
    this.description,
    this.inFavorites,
    this.inCart,
  });

  int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image;
  String name;
  String description;
  bool inFavorites;
  bool inCart;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        id: json["id"],
        price: json["price"],
        oldPrice: json["old_price"],
        discount: json["discount"],
        image: json["image"],
        name: json["name"],
        description: json["description"],
        inFavorites: json["in_favorites"],
        inCart: json["in_cart"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "old_price": oldPrice,
        "discount": discount,
        "image": image,
        "name": name,
        "description": description,
        "in_favorites": inFavorites,
        "in_cart": inCart,
      };
}
