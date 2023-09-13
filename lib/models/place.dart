import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  PlaceLocation({required this.lat, required this.lng, required this.adress});
  final double lng;
  final double lat;
  final String adress;
}

class Place {
  Place({required this.title, required this.image,required this.location,String? id,}) : id =id?? uuid.v4();
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
