import 'package:shared_preferences/shared_preferences.dart';

class MapPref {
  static const zoom = 'zoom';

  static void saveZoomValue(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(MapPref.zoom, value);
  }
}
