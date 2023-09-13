import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.pickedImage});

  final void Function(File image) pickedImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _tookImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final tookImage1 = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      //imageQuality:
    );
    if (tookImage1 == null) {
      _takePicture();
    }
    setState(() {
      _tookImage = File(tookImage1!.path);
    });
    widget.pickedImage(_tookImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      label: const Text('Teke Picture'),
      icon: const Icon(Icons.camera),
      onPressed: _takePicture,
    );
    if (_tookImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _tookImage!,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.primary)),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
