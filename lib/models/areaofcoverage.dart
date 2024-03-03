class AreaOfCoverage {
  int? id;
  final String latitude;
  final String longitude;
  final String locationName;
  AreaOfCoverage({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  factory AreaOfCoverage.fromJson(Map<String, dynamic> json) {
    return AreaOfCoverage(
      id: json["id"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      locationName: json["locationName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "locationName": locationName,
      };
}
