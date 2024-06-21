import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ams/api/ApiClient.dart';

final locationControllerProvider = Provider((ref) => LocationController());

class LocationController {
  final storage = FlutterSecureStorage();

  Future<bool> isWithinCompanyRadius() async {
    try {
      Position position = await _determinePosition();
      print(position.longitude);
      print(position.latitude);
      String? companyId = await storage.read(key: 'companyId');
      print(companyId);
      String? token = await storage.read(key: 'token');

      if (companyId == null || token == null) {
        throw Exception('Company ID or token not found');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiClient.baseUrl}/api/users/isWithinRadius/$companyId?userLat=${position.latitude}&userLon=${position.longitude}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return true;
      } else {
        throw Exception('Failed to check location');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> resetLocationPermissions() async {
    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings();
  }
}
