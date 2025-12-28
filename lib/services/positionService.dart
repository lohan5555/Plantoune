import 'package:geolocator/geolocator.dart';

class PositionService{

  Future<Position?> getCurrentPosition() async {
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}