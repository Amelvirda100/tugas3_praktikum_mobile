class ClothesResponse {
  String? status;
  String? message;
  List<Clothes>? data;

  ClothesResponse({this.status, this.message, this.data});

  ClothesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? json['message'];
    message = json['message'] ?? json['status'];

    if (json['data'] != null) {
      data = <Clothes>[];
      // json['data'] bisa list atau map
      if (json['data'] is List) {
        (json['data'] as List).forEach((v) {
          data!.add(Clothes.fromJson(v));
        });
      } else if (json['data'] is Map<String, dynamic>) {
        data!.add(Clothes.fromJson(json['data']));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['status'] = status;
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Clothes {
  int? id;
  String? name;
  int? price;
  String? category;
  String? brand;
  int? sold;
  double? rating;
  int? stock;
  int? yearReleased;
  String? material;

  Clothes({
    this.id,
    this.name,
    this.price,
    this.category,
    this.brand,
    this.sold,
    this.rating,
    this.stock,
    this.yearReleased,
    this.material,
  });

  Clothes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    category = json['category'];
    brand = json['brand'];
    sold = json['sold'];
    rating = (json['rating'] != null)
        ? json['rating'].toDouble()
        : null;
    stock = json['stock'];
    yearReleased = json['yearReleased'];
    material = json['material'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['price'] = price;
    json['category'] = category;
    json['brand'] = brand;
    json['sold'] = sold;
    json['rating'] = rating;
    json['stock'] = stock;
    json['yearReleased'] = yearReleased;
    json['material'] = material;
    return json;
  }
}
