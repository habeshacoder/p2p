// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:p2p/models/user_model.dart';

enum ApprovedStatusEnum {
  PENDING,
  APPROVED,
  REJECTED,
}

class DeliveryAgentModel {
  dynamic id;
  String? agentIdNumber;
  String? profileImageUrl;
  CarInfo? carInfo;
  MotorBikeInfo? motorBikeInfo;
  BikeInfo? bikeInfo;
  String? approvedStatus;
  String? rejectReason;
  bool? isAgentAvailable;
  List<dynamic>? areaOfCoverageIds;
  User? user;
  DateTime? createdOn;
  bool? agentFeatured;

  DeliveryAgentModel({
    this.id,
    this.agentIdNumber,
    this.profileImageUrl,
    this.carInfo,
    this.motorBikeInfo,
    this.bikeInfo,
    this.approvedStatus,
    this.rejectReason,
    this.isAgentAvailable,
    this.areaOfCoverageIds,
    this.user,
    this.createdOn,
    this.agentFeatured,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'agentIdNumber': agentIdNumber,
      'profileImageUrl': profileImageUrl,
      'carInfo': carInfo?.toJson(),
      'motorBikeInfo': motorBikeInfo?.toJson(),
      'bikeInfo': bikeInfo?.toJson(),
      'approvedStatus': 'PENDING',
      'rejectReason': rejectReason,
      'isAgentAvailable': isAgentAvailable,
      'areaOfCoverageIds': areaOfCoverageIds,
      'user': user!.toJson(),
      'createdOn': createdOn?.millisecondsSinceEpoch,
      'agentFeatured': agentFeatured,
    };
  }

  factory DeliveryAgentModel.fromMap(Map<String, dynamic> map) {
    return DeliveryAgentModel(
      id: map['id'] != null ? map['id'] : null,
      agentIdNumber:
          map['agentIdNumber'] != null ? map['agentIdNumber'] as String : null,
      profileImageUrl: map['profileImageUrl'] != null
          ? map['profileImageUrl'] as String
          : null,
      carInfo: map['carInfo'] != null
          ? CarInfo.fromMap(map['carInfo'] as Map<String, dynamic>)
          : null,
      motorBikeInfo: map['motorBikeInfo'] != null
          ? MotorBikeInfo.fromMap(map['motorBikeInfo'] as Map<String, dynamic>)
          : null,
      bikeInfo: map['bikeInfo'] != null
          ? BikeInfo.fromMap(map['bikeInfo'] as Map<String, dynamic>)
          : null,
      approvedStatus: map['approvedStatus'],
      rejectReason:
          map['rejectReason'] != null ? map['rejectReason'] as String : null,
      isAgentAvailable: map['isAgentAvailable'] != null
          ? map['isAgentAvailable'] as bool
          : null,
      areaOfCoverageIds: map['areaOfCoverageIds'],
      user: map['user'] != null ? User.fromJson(map['user']) : null,
      createdOn:
          map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
      agentFeatured: map['agentFeatured'] != null ? map['agentFeatured'] : null,
    );
  }

  factory DeliveryAgentModel.fromJson(String source) =>
      DeliveryAgentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CarInfo {
  dynamic id;
  String? plateNumber;
  String? make;
  String? model;
  String? color;
  String? imageUrl;
  String? carType;
  dynamic loadingCapacity;
  String? description;
  DateTime? createdOn;
  DateTime? updatedOn;

  CarInfo({
    this.id,
    this.plateNumber,
    this.make,
    this.model,
    this.color,
    this.imageUrl,
    this.carType,
    this.loadingCapacity,
    this.description,
    this.createdOn,
    this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'plateNumber': plateNumber,
      'make': make,
      'model': model,
      'color': color,
      'imageUrl': imageUrl,
      'carType': carType,
      'loadingCapacity': loadingCapacity,
      'description': description,
      'createdOn': createdOn?.millisecondsSinceEpoch,
      'updatedOn': updatedOn?.millisecondsSinceEpoch,
    };
  }

  factory CarInfo.fromMap(Map<String, dynamic> map) {
    return CarInfo(
      id: map['id'] != null ? map['id'] : null,
      plateNumber:
          map['plateNumber'] != null ? map['plateNumber'] as String : null,
      make: map['make'] != null ? map['make'] as String : null,
      model: map['model'] != null ? map['model'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      carType: map['carType'] != null ? map['carType'] as String : null,
      loadingCapacity:
          map['loadingCapacity'] != null ? map['loadingCapacity'] : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      createdOn:
          map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
    );
  }

  // String toJson() => json.encode(toMap());

  factory CarInfo.fromJson(String source) =>
      CarInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarInfo(id: $id, plateNumber: $plateNumber, make: $make, model: $model, color: $color, imageUrl: $imageUrl, carType: $carType, loadingCapacity: $loadingCapacity, description: $description, createdOn: $createdOn, updatedOn: $updatedOn)';
  }
}

class MotorBikeInfo {
  dynamic id;
  String? plateNumber;
  String? make;
  String? imageUrl;
  String? description;
  String? color;
  DateTime? createdOn;
  DateTime? updatedOn;

  MotorBikeInfo({
    this.id,
    this.plateNumber,
    this.make,
    this.imageUrl,
    this.description,
    this.color,
    this.createdOn,
    this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'plateNumber': plateNumber,
      'make': make,
      'imageUrl': imageUrl,
      'description': description,
      'color': color,
      'createdOn': createdOn?.millisecondsSinceEpoch,
      'updatedOn': updatedOn?.millisecondsSinceEpoch,
    };
  }

  factory MotorBikeInfo.fromMap(Map<String, dynamic> map) {
    return MotorBikeInfo(
      id: map['id'] != null ? map['id'] : null,
      plateNumber:
          map['plateNumber'] != null ? map['plateNumber'] as String : null,
      make: map['make'] != null ? map['make'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      createdOn:
          map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
    );
  }

  factory MotorBikeInfo.fromJson(String source) =>
      MotorBikeInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MotorBikeInfo(id: $id, plateNumber: $plateNumber, make: $make, imageUrl: $imageUrl, description: $description, color: $color, createdOn: $createdOn, updatedOn: $updatedOn)';
  }
}

class BikeInfo {
  dynamic id;
  String? imageUrl;
  String? description;
  String? color;
  DateTime? createdOn;
  DateTime? updatedOn;

  BikeInfo({
    this.id,
    this.imageUrl,
    this.description,
    this.color,
    this.createdOn,
    this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
      'color': color,
      'createdOn': createdOn?.millisecondsSinceEpoch,
      'updatedOn': updatedOn?.millisecondsSinceEpoch,
    };
  }

  factory BikeInfo.fromMap(Map<String, dynamic> map) {
    return BikeInfo(
      id: map['id'] != null ? map['id'] : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      createdOn:
          map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
    );
  }

  factory BikeInfo.fromJson(String source) =>
      BikeInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BikeInfo(id: $id, imageUrl: $imageUrl, description: $description, color: $color, createdOn: $createdOn, updatedOn: $updatedOn)';
  }
}
