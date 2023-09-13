
import 'package:favorite_places/screens/adding_screen.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/add_provider.dart';


class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});
    @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
 late Future<void>_placesFuture;

 @override
  void initState() {
    super.initState();
    _placesFuture= ref.read(add.notifier).loadPlaces();
  }
  

  @override
  Widget build(BuildContext context,) {

    final place = ref.watch(add);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddingScreen(),
    ));
  }, icon: const Icon(Icons.add))
        ],
      ),
      body:FutureBuilder(future: _placesFuture, builder: (context, snapshot) =>
        snapshot.connectionState==ConnectionState.waiting ?const   CircularProgressIndicator():       PlacesList(place: place)

      ,)
      
      
    );
  }
}
