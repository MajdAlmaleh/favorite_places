import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:favorite_places/screens/map_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.setPosition});
  final void Function(PlaceLocation placeLocation) setPosition;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LocationData? locationData;
  String get pickedLocation {
    final lng = locationData!.longitude;
    final ltd = locationData!.latitude;
    return 'https://www.mapquestapi.com/staticmap/v5/map?key=ckui89wmGwVQ7wzeqWd9ahqKjFevTYFU&locations=$ltd,$lng&size=@2x&defaultMarker=marker-sm-22407F-3B5998&zoom=11&size=600,400@2x';
  }

  PlaceLocation? placeLocation;
  bool isGettingLocation = false;
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();
    print(locationData!.latitude);
    print(locationData!.longitude);

    final lng = locationData!.longitude;
    final ltd = locationData!.latitude;
    final url = Uri.parse(
        'https://www.mapquestapi.com/geocoding/v1/reverse?key=ckui89wmGwVQ7wzeqWd9ahqKjFevTYFU&location=$ltd,$lng&includeRoadMetadata=true&includeNearestIntersection=true');

    final response = await http.get(url);

    final resData = json.decode(response.body);
    final adress =
        '${resData['results'][0]['locations'][0]['adminArea1']} ,${resData['results'][0]['locations'][0]['adminArea5']}';
    print(adress);
    if (ltd == null || lng == null) {
      return;
    }

    setState(() {
      placeLocation = PlaceLocation(lat: ltd, lng: lng, adress: adress);

      isGettingLocation = false;
    });
    widget.setPosition(placeLocation!);
  }

  PickedData? pickedData;
  String get pickedDataa {
    final lng = pickedData!.latLong.longitude;
    final ltd = pickedData!.latLong.latitude;
    return 'https://www.mapquestapi.com/staticmap/v5/map?key=ckui89wmGwVQ7wzeqWd9ahqKjFevTYFU&locations=$ltd,$lng&size=@2x&defaultMarker=marker-sm-22407F-3B5998&zoom=11&size=600,400@2x';
  }

  void movedLocation() async {
    pickedData = await Navigator.of(context).push<PickedData>(
      MaterialPageRoute(
        builder: (context) => const MapSelect(
          isSelecting: true,
        ),
      ),
    );
    if (pickedData == null) {
      return;
    }
    locationData = null;
    setState(() {
      placeLocation = PlaceLocation(
          lat: pickedData!.latLong.latitude,
          lng: pickedData!.latLong.longitude,
          adress: pickedData!.address);
          widget.setPosition(placeLocation!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location set',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if (isGettingLocation) {
      content = const CircularProgressIndicator();
    }
    if (locationData != null) {
      content = Image.network(
        pickedLocation,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }
    if (pickedData != null) {
      content = Image.network(
        pickedDataa,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              alignment: Alignment.center,
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Theme.of(context).colorScheme.primary),
              ),
              child: content),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: movedLocation,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        )
      ],
    );
  }
}
