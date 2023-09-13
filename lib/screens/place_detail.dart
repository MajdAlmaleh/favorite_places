import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});
  final Place place;

  String get pickedLocation {
    final lng = place.location.lng;
    final ltd = place.location.lat;
    return 'https://www.mapquestapi.com/staticmap/v5/map?key=ckui89wmGwVQ7wzeqWd9ahqKjFevTYFU&locations=$ltd,$lng&size=@2x&defaultMarker=marker-sm-22407F-3B5998&zoom=11&size=600,400@2x';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapSelect(isSelecting: false,
                        lat: place.location.lat,
                        lng: place.location.lng,
                      ),
                    ));
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(pickedLocation),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54])),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    place.location.adress,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
