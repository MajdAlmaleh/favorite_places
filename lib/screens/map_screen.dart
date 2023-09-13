import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class MapSelect extends StatefulWidget {
  const MapSelect({
    super.key,
    this.lat = 23,
    this.lng = 89,
    required this.isSelecting
  });
  final double lat;
  final double lng;
  final bool isSelecting;
  // final PlaceLocation location;required this.location

  @override
  State<MapSelect> createState() => _MapSelectState();
}

class _MapSelectState extends State<MapSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting?'Choose a location':'Place location'
        ),
      ),
      body: FlutterLocationPicker(

          initPosition: LatLong(widget.lat, widget.lng),
          selectLocationButtonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          selectedLocationButtonTextstyle:
              const TextStyle(fontSize: 18, color: Colors.white),
          selectLocationButtonText: widget.isSelecting?'Set Current Location':'',
          selectLocationButtonLeadingIcon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
          initZoom: 11,
          minZoomLevel: 4,
          maxZoomLevel: 16,
          trackMyPosition: widget.isSelecting,
          onError: (e) => print(e),
          onPicked: (pickedData) {
            widget.isSelecting?Navigator.of(context).pop(pickedData):
             print(pickedData.latLong.latitude);
           /* print(pickedData.latLong.longitude);
            print(pickedData.address);
            print(pickedData.addressData['country']); */
          
          }),
    );
  }
}
