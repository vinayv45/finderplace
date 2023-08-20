import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/models/location_result_model.dart';

class PlaceController extends GetxController {
  RxList<String> types = <String>[].obs;
  RxString tabString = "".obs;
  RxList<LocationResult> locationResults = <LocationResult>[].obs;
  RxList<LocationResult> filterList = <LocationResult>[].obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxString errorText = "Loading....".obs;
  @override
  void onInit() {
    getCurrentLocation();
    super.onInit();
  }

  Future<List<LocationResult>> getPlaces(
      {double? latitude, double? longitude}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      errorText.value = "Fetching data....";
      update();

      String url =
          "https://maps.googleapis.com/maps/api/place/search/json?location=$latitude,$longitude&rankby=distance&key=AIzaSyB2Az9gVUzQULUc55xQD9AE7gj9Ni5hvJk&sensor=true";
      var response = await get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        sharedPreferences.clear();
        var jsonData = json.decode(response.body);
        sharedPreferences.setString(
            "locationList", jsonEncode(jsonData['results']));
        String? storedJsonData = sharedPreferences.getString('locationList');
        sharedPreferences.setDouble("lat", latitude!);
        sharedPreferences.setDouble("lag", longitude!);
        List data = json.decode(storedJsonData!);

        update();
        return data.map((e) => LocationResult.fromJson(e)).toList();
      } else {
        errorText.value = "Something went wrong please try later.";
        update();
        return [];
      }
    } on Exception catch (e) {
      if (e is SocketException) {
        errorText.value = "Please check your internet connection.";
      } else {
        errorText.value = "Please try again after some time.";
      }
      return [];
    }
  }

  Future<void> getCurrentLocation() async {
    locationResults.clear();
    errorText.value = "Loading....";
    update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Location location = Location();
      LocationData _locationData;
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          errorText.value = "please turn on location.";
          update();
          return;
        }
      }

      _permissionGranted = await location.hasPermission();

      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          errorText.value = "please turn on location.";
          update();
          return;
        }
      }
      _locationData = await location.getLocation();

      List<LocationResult> response = await getPlaces(
          latitude: _locationData.latitude, longitude: _locationData.longitude);
      locationResults.addAll(response);
      List<String> _resultTypes = [];

      for (var element in response) {
        _resultTypes.addAll([...element.types, ..._resultTypes]);
      }
      List<String> _allUniqueTypes = [];

      for (var i = 0; i < _resultTypes.length; i++) {
        if (_allUniqueTypes.contains(_resultTypes[i])) {
        } else {
          _allUniqueTypes.add(_resultTypes[i]);
        }
      }
      types.value = _allUniqueTypes;
      if (types.isNotEmpty) {
        tabString.value = types[0];
        typesList(types[0]);
      }

      latitude.value = _locationData.latitude!;
      longitude.value = _locationData.longitude!;
      update();
    } else if (sharedPreferences.getString('locationList') != null) {
      double? lat = sharedPreferences.getDouble("lat");
      double? lag = sharedPreferences.getDouble("lag");
      latitude.value = lat!;
      longitude.value = lag!;
      String? storedJsonData = sharedPreferences.getString('locationList');
      List data = json.decode(storedJsonData!);
      var data2 = data.map((e) => LocationResult.fromJson(e)).toList();
      locationResults.addAll(data2);
      List<String> _resultTypes = [];
      for (var element in data2) {
        _resultTypes.addAll([...element.types, ..._resultTypes]);
      }
      List<String> _allUniqueTypes = [];

      for (var i = 0; i < _resultTypes.length; i++) {
        if (_allUniqueTypes.contains(_resultTypes[i])) {
        } else {
          _allUniqueTypes.add(_resultTypes[i]);
        }
      }
      types.value = _allUniqueTypes;
      if (types.isNotEmpty) {
        tabString.value = types[0];
        typesList(types[0]);
      }
    } else {
      errorText.value = "Check the Internet Connectivity";
      update();
    }
  }

  typesList(String typesList) {
    filterList.clear();
    List<LocationResult> filteredResults = locationResults.where((location) {
      return location.types.contains(typesList);
    }).toList();
    filterList.value = filteredResults;

    update();
  }

  Future<void> searchPlaceName(String searchText) async {
    filterList.clear();
    filterList.value = locationResults.where((item) {
      return item.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    update();
  }

  double calculateDistance(
    double userLatitude,
    double userLongitude,
    double currentLatitude,
    double currentlongitude,
  ) {
    const double earthRadius = 6371;
    double lat1 = userLatitude * pi / 180;
    double lon1 = userLongitude * pi / 180;
    double lat2 = currentLatitude * pi / 180;
    double lon2 = currentlongitude * pi / 180;
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  String formatDistance(double distance) {
    if (distance >= 1) {
      return '${distance.toStringAsFixed(2)} km';
    } else {
      return '${(distance * 1000).toStringAsFixed(0)} meters';
    }
  }
}
