import 'package:geolocator/geolocator.dart';

class Location {
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Checking location permissions
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled!');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied!');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied. Thus, this action cannot be performed.');
    }

    //Getting user location
    return await Geolocator.getCurrentPosition();
  }
}
