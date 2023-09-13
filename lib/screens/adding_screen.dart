import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/providers/add_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddingScreen extends ConsumerStatefulWidget {
  const AddingScreen({super.key});

  @override
  ConsumerState<AddingScreen> createState() => _AddingScreenState();
}

class _AddingScreenState extends ConsumerState<AddingScreen> {
  final _controller = TextEditingController();
  File? image;
  PlaceLocation? placeLocation;
  void _saveAdded() {
    if (_controller.text.trim().isEmpty) {
      return;
    }
   /*  print(image.toString());
    print(_controller.text);
    print(placeLocation); */
    ref.read(add.notifier).added(Place(
        title: _controller.text, image: image!, location: placeLocation!));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                decoration: const InputDecoration(
                  label: Text(
                    'Title',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(height: 8),
            ImageInput(
              pickedImage: (image1) {
                image = image1;
              },
            ),
            const SizedBox(height: 8),
            LocationInput(
              setPosition: (position) {
                placeLocation = position;
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: _saveAdded,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Place'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
