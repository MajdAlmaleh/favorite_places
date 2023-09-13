import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({
    super.key,
    required this.place,
  });
  final List<Place> place;

  @override
  Widget build(BuildContext context) {
    return place.isEmpty
        ? Center(
            child: Text(
              'No Places added.',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          )
        : ListView.builder(
            itemCount: place.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(place[index].image),
                    radius: 26,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return PlaceDetails(
                            place: place[index],
                          );
                        },
                      ),
                    );
                  },
                  title: Text(
                    place[index].title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  subtitle: Text(place[index].location.adress),
                ),
              );
            },
          );
  }
}
