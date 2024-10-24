import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';

class DeviceInfoService {
  double? latitude;
  double? longitude;
  String ipAddress = '';
  String deviceType = '';
  String os = '';
  String uniqueIdentifier = '';

  Future<void> initDeviceInfo() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      } 

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
          

      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceType = 'Android';
        os = 'Android ${build.version.release}';
        uniqueIdentifier = '${build.id}-${build.manufacturer}-${build.model}';
        
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceType = 'iOS';
        os = '${data.systemName} ${data.systemVersion}';
        uniqueIdentifier = data.identifierForVendor ?? '${data.name}-${data.model}-${data.utsname.machine}';
      }

      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            ipAddress = addr.address;
            break;
          }
        }
        if (ipAddress.isNotEmpty) break;
      }

      // Generate and store a UUID if it doesn't exist
      // final prefs = await SharedPreferences.getInstance();
      // uniqueIdentifier = prefs.getString('uniqueIdentifier') ?? '';
      // if (uniqueIdentifier.isEmpty) {
      //   uniqueIdentifier = const Uuid().v4();
      //   await prefs.setString('uniqueIdentifier', uniqueIdentifier);
      // }
    } catch (e) {
      print(e);
      throw Exception('Failed to get device info: $e');
    }
  }
}
