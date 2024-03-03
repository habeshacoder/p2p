import 'package:p2p/models/item.dart';
import 'package:p2p/models/user_model.dart';

class Order {
  Order({
    required this.id,
    required this.receiverName,
    required this.receiverPhoneNumber,
    required this.deliveryStatus,
    required this.userId,
    required this.OrderedBy,
    required this.orderedDate,
    required this.deliveryItem,
    required this.quotedPrice,
    required this.finalPrice,
    required this.isPayed,
    required this.pickupPoint,
    required this.pickupDate,
    required this.destinationPoint,
    required this.destinationDate,
    required this.transportationRequirement,
    required this.vehicleType,
    required this.remark,
    required this.deliveryProgressId,
    required this.createdOn,
  });
  final int? id;
  final int? userId;
  final User? OrderedBy;
  final DateTime? orderedDate;
  final List<Item> deliveryItem;
  final double? quotedPrice;
  final double? finalPrice;
  final String? receiverPhoneNumber;
  final String? deliveryStatus;
  final bool? isPayed;
  final Point? pickupPoint;
  final DateTime? pickupDate;
  final Point? destinationPoint;
  final DateTime? destinationDate;
  final String? transportationRequirement;
  final String? vehicleType;
  final String? receiverName;
  final String? remark;
  final int? deliveryProgressId;
  final DateTime? createdOn;

  factory Order.fromJson(Map<String, dynamic> json) {
    print('oickuo date:---------------:${json["pickupDate"]}');
    return Order(
      id: json["id"],
      OrderedBy: User.fromJson(json["orderedBy"]),
      userId: json["orderedBy"]?["id"],
      receiverPhoneNumber: json["receiverPhone"],
      deliveryStatus: json["deliveryStatus"],
      orderedDate: json["orderedDate"] != null
          ? DateTime.tryParse(json["orderedDate"])
          : null,
      deliveryItem: json["deliveryItem"] != null
          ? List<Item>.from(json["deliveryItem"].map((x) => Item.fromJson(x)))
          : [],
      quotedPrice: json["quotedPrice"] != null ? json["quotedPrice"] : 0.0,
      finalPrice:
          json["finalPrice"] != null ? json["finalPrice"].toDouble() : 0.0,
      isPayed: json["isPayed"],
      pickupPoint: json["pickupPoint"] != null
          ? Point.fromJson(json["pickupPoint"])
          : null,
      pickupDate: json["pickupDate"] != null
          ? DateTime.tryParse(json["pickupDate"])
          : null,
      destinationPoint: json["destinationPoint"] != null
          ? Point.fromJson(json["destinationPoint"])
          : null,
      destinationDate: json["destinationDate"] != null
          ? DateTime.tryParse(json["destinationDate"])
          : null,
      transportationRequirement: null,
      vehicleType: json["vehicleType"],
      receiverName: json["receiverName"],
      remark: json["remark"],
      deliveryProgressId: null,
      createdOn: json["createdOn"] != null
          ? DateTime.tryParse(json["createdOn"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    print("OrderId:.....${id}");
    List<Map<String, dynamic>> deliveryItems =
        deliveryItem.map((order) => order.toJson()).toList();
    print("deliveryItem:.....$deliveryItem");
    print("deliveryItem:.....$deliveryItems");

    return {
      "id": id,
      "deliveryItem": deliveryItems,
      "quotedPrice": null,
      "finalPrice": null,
      "isPayed": false,
      "pickupPoint": {
        "latitude": pickupPoint!.latitude,
        "longitude": pickupPoint!.longitude,
        "street": pickupPoint!.street,
        "city": pickupPoint!.city,
        "country": pickupPoint!.country,
        "remark": pickupPoint!.remark,
      },
      "pickupDate": pickupDate!.toIso8601String(),
      "destinationPoint": {
        "latitude": destinationPoint!.latitude,
        "longitude": destinationPoint!.longitude,
        "street": destinationPoint!.street,
        "city": destinationPoint!.city,
        "country": destinationPoint!.country,
        "remark": destinationPoint!.remark
      },
      "destinationDate": destinationDate!.toIso8601String(),
      "vehicleType": vehicleType,
      "remark": remark,
      "receiverName": receiverName,
      "deliveryStatus": deliveryStatus,
      "receiverPhone": receiverPhoneNumber,
      "receiverSignature": null
    };
  }
}

class DeliveryItem {
  DeliveryItem({
    required this.id,
    required this.name,
    required this.itemCategory,
    required this.sizeMeasurement,
    required this.size,
    required this.isBrittle,
    required this.isFlammable,
    required this.isSensitive,
    required this.other,
    required this.remark,
    required this.createdOn,
    required this.updatedOn,
  });

  final int? id;
  final String? name;
  final List<ItemCategory> itemCategory;
  final String? sizeMeasurement;
  final String? size;
  final bool? isBrittle;
  final bool? isFlammable;
  final bool? isSensitive;
  final String? other;
  final String? remark;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      id: json["id"],
      name: json["name"],
      itemCategory: json["itemCategory"] == null
          ? []
          : List<ItemCategory>.from(
              json["itemCategory"]!.map((x) => ItemCategory.fromJson(x))),
      sizeMeasurement: json["sizeMeasurement"],
      size: json["size"],
      isBrittle: json["isBrittle"],
      isFlammable: json["isFlammable"],
      isSensitive: json["isSensitive"],
      other: json["other"],
      remark: json["remark"],
      createdOn: DateTime.tryParse(json["createdOn"] ?? ""),
      updatedOn: DateTime.tryParse(json["updatedOn"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "itemCategory": itemCategory.map((x) => x?.toJson()).toList(),
        "sizeMeasurement": sizeMeasurement,
        "size": size,
        "isBrittle": isBrittle,
        "isFlammable": isFlammable,
        "isSensitive": isSensitive,
        "other": other,
        "remark": remark,
        "createdOn": createdOn?.toIso8601String(),
        "updatedOn": updatedOn?.toIso8601String(),
      };
}

class Point {
  Point({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.street,
    required this.city,
    required this.country,
    required this.remark,
    required this.createdOn,
    required this.updatedOn,
  });

  final int? id;
  final double? latitude;
  final double? longitude;
  final String? street;
  final String? city;
  final String? country;
  final String? remark;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json["id"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      street: json["street"],
      city: json["city"],
      country: json["country"],
      remark: json["remark"],
      createdOn: DateTime.tryParse(json["createdOn"] ?? ""),
      updatedOn: DateTime.tryParse(json["updatedOn"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "street": street,
        "city": city,
        "country": country,
        "remark": remark,
        "createdOn": createdOn?.toIso8601String(),
        "updatedOn": updatedOn?.toIso8601String(),
      };
}
