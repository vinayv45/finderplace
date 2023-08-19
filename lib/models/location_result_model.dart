// To parse this JSON data, do
//
//     final locationResult = locationResultFromJson(jsonString);

import 'dart:convert';

LocationResult locationResultFromJson(String str) =>
    LocationResult.fromJson(json.decode(str));

String locationResultToJson(LocationResult data) => json.encode(data.toJson());

class LocationResult {
  String businessStatus;
  Geometry geometry;
  String icon;
  String iconBackgroundColor;
  String iconMaskBaseUri;
  String name;
  List<Photo> photos;
  String placeId;
  PlusCode plusCode;

  List<String> types;
  int userRatingsTotal;
  String vicinity;

  LocationResult({
    required this.businessStatus,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.photos,
    required this.placeId,
    required this.plusCode,
    required this.types,
    required this.userRatingsTotal,
    required this.vicinity,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) => LocationResult(
        businessStatus: json["business_status"] ?? "",
        geometry: Geometry.fromJson(json["geometry"]),
        icon: json["icon"],
        iconBackgroundColor: json["icon_background_color"],
        iconMaskBaseUri: json["icon_mask_base_uri"],
        name: json["name"],
        photos: List<Photo>.from(
            (json["photos"] ?? []).map((x) => Photo.fromJson(x))),
        placeId: json["place_id"],
        plusCode: PlusCode.fromJson(json["plus_code"] ?? {}),
        types: List<String>.from(json["types"].map((x) => x)),
        userRatingsTotal: json["user_ratings_total"] ?? 0,
        vicinity: json["vicinity"],
      );

  Map<String, dynamic> toJson() => {
        "business_status": businessStatus,
        "geometry": geometry.toJson(),
        "icon": icon,
        "icon_background_color": iconBackgroundColor,
        "icon_mask_base_uri": iconMaskBaseUri,
        "name": name,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "place_id": placeId,
        "plus_code": plusCode.toJson(),
        "types": List<dynamic>.from(types.map((x) => x)),
        "user_ratings_total": userRatingsTotal,
        "vicinity": vicinity,
      };
}

class Geometry {
  LocationModel location;
  Viewport viewport;

  Geometry({
    required this.location,
    required this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: LocationModel.fromJson(json["location"]),
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "viewport": viewport.toJson(),
      };
}

class LocationModel {
  double lat;
  double lng;

  LocationModel({
    required this.lat,
    required this.lng,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  LocationModel northeast;
  LocationModel southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: LocationModel.fromJson(json["northeast"]),
        southwest: LocationModel.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}

class Photo {
  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        height: json["height"],
        htmlAttributions:
            List<String>.from(json["html_attributions"].map((x) => x)),
        photoReference: json["photo_reference"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
        "photo_reference": photoReference,
        "width": width,
      };
}

class PlusCode {
  String compoundCode;
  String globalCode;

  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"] ?? "",
        globalCode: json["global_code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}
