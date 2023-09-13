import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getdb() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,adress TEXT)');
  }, version: 1);
  return db;
}

class AddingNotifier extends StateNotifier<List<Place>> {
  AddingNotifier() : super(const []);

 Future<void> loadPlaces() async {
      final db = await getdb();
      final data = await db.query('user_places');
      final places = data
          .map(
            (row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['image'] as String),
              location: PlaceLocation(
                  lat: row['lat'] as double,
                  lng: row['lng'] as double,
                  adress: row['adress'] as String),
            ),
          )
          .toList();
      state = places;
    }



  void added(Place place) async {
   

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$fileName');
    final db = await getdb();
    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.lat,
      'lng': place.location.lng,
      'adress': place.location.adress,
    });

    state = [
      ...state,
      Place(title: place.title, image: copiedImage, location: place.location)
    ];
  }
}

final add = StateNotifierProvider<AddingNotifier, List<Place>>(
    (ref) => AddingNotifier());
