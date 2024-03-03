class Item {
  Item({
    this.id,
    required this.name,
    required this.description,
    required this.sizeMeasurement,
    required this.size,
    required this.isBrittle,
    required this.isFlammable,
    required this.isSensitive,
    required this.other,
    required this.remark,
    this.createdOn,
    this.updatedOn,
  });

  final int? id;
  final String? name;
  // final List<ItemCategory> itemCategory;
  final String? description;
  final String? sizeMeasurement;
  final double? size;
  final bool? isBrittle;
  final bool? isFlammable;
  final bool? isSensitive;
  final String? other;
  final String? remark;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory Item.fromJson(Map<String, dynamic> json) {
    print('item from json:${json["description"]} ');
    return Item(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      sizeMeasurement: json["sizeMeasurement"],
      size:
          json["size"] != null ? double.tryParse(json["size"].toString()) : 0.0,
      isBrittle: json["isBrittle"] ?? false,
      isFlammable: json["isFlammable"] ?? false,
      isSensitive: json["isSensitive"] ?? false,
      other: json["other"],
      remark: json["remark"],
      createdOn: json["createdOn"] != null
          ? DateTime.tryParse(json["createdOn"])
          : null,
      updatedOn: json["updatedOn"] != null
          ? DateTime.tryParse(json["updatedOn"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sizeMeasurement": sizeMeasurement,
        "size": size,
        "isBrittle": isBrittle,
        "isFlammable": isFlammable,
        "description": description,
        "isSensitive": isSensitive,
        "other": other,
        "remark": remark,
        "createdOn": createdOn?.toIso8601String(),
        "updatedOn": updatedOn?.toIso8601String(),
      };
}

class ItemCategory {
  ItemCategory({
    this.id,
    required this.category,
    this.createdOn,
    this.updatedOn,
  });

  final int? id;
  final String? category;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      id: json["id"],
      category: json["category"],
      createdOn: DateTime.tryParse(json["createdOn"] ?? ""),
      updatedOn: DateTime.tryParse(json["updatedOn"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "createdOn": createdOn?.toIso8601String(),
        "updatedOn": updatedOn?.toIso8601String(),
      };
}
