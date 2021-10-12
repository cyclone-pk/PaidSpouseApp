import 'package:flutter/material.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:matriapp/Screens/seach_location.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UpdateLocation extends StatefulWidget {
  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  Map _newAddress;
  @override
  void initState() {
    getLocationCoordinates().then((updateAddress) {
      setState(() {
        _newAddress = updateAddress;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ListTile(
          title: Text(
            "Use current location",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_newAddress != null
              ? _newAddress['PlaceName'] ?? 'Fetching..'
              : 'Unable to load...'),
          leading: Icon(
            Icons.location_searching_rounded,
            color: Colors.white,
          ),
          onTap: () async {
            if (_newAddress == null) {
              await getLocationCoordinates().then((updateAddress) {
                print(updateAddress);
                setState(() {
                  _newAddress = updateAddress;
                });
              });
            } else {
              print("-------object");
              Navigator.pop(context, _newAddress);
            }
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * .6,
        child: MapBoxAutoCompleteWidget(
          language: 'en',
          closeOnSelect: false,
          apiKey: mapboxApi,
          limit: 10,
          hint: 'Enter your city name',
          onSelect: (place) {
            Map obj = {};
            obj['PlaceName'] = place.placeName;
            obj['latitude'] = place.geometry.coordinates[1];
            obj['longitude'] = place.geometry.coordinates[0];
            Navigator.pop(context, obj);
          },
        ),
      ),
    );
  }
}

Future<Map> getLocationCoordinates() async {
  loc.Location location = loc.Location();
  try {
    await location.serviceEnabled().then((value) async {
      if (!value) {
        await location.requestService();
      }
    });
    final coordinates = await location.getLocation();
    return await coordinatesToAddress(
    );
  } catch (e) {
    print(e);
    return null;
  }
}
///Call this function
Future coordinatesToAddress() async {
  try {
  ///Get current location
  Map<String, dynamic> obj = {};
  //Geolocator _geolocator = Geolocator();
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  String latitude = "";
  String longitude = "";
  String address = "";
  Position position = await _geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);///Here you have choose level of distance
  latitude = position.latitude.toString() ?? '';
  longitude = position.longitude.toString() ?? '';
  var placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  address ='${placemarks.first.name.isNotEmpty ? placemarks.first.name + ', ' : ''}${placemarks.first.thoroughfare.isNotEmpty ? placemarks.first.thoroughfare + ', ' : ''}${placemarks.first.subLocality.isNotEmpty ? placemarks.first.subLocality+ ', ' : ''}${placemarks.first.locality.isNotEmpty ? placemarks.first.locality+ ', ' : ''}${placemarks.first.subAdministrativeArea.isNotEmpty ? placemarks.first.subAdministrativeArea + ', ' : ''}${placemarks.first.postalCode.isNotEmpty ? placemarks.first.postalCode + ', ' : ''}${placemarks.first.administrativeArea.isNotEmpty ? placemarks.first.administrativeArea : ''}';
  // print("latitude"+latitude);
  // print("longitude"+longitude);
  // print("adreess"+address);

  obj['PlaceName'] = address;
  obj['latitude'] = latitude;
  obj['longitude'] = longitude;

  return obj;
  } catch (_) {
    print(_);
    return null;
  }
}
