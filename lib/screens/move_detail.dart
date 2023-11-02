import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MoveDetailStep extends StatefulWidget {
  final double difficulty;
  final String description;
  final String name;
  final void Function(String, String, int) onChanged;
//  final XFile? image;

  MoveDetailStep({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.onChanged,
    //  required this.image,
  });

  @override
  _MoveDetailStepState createState() => _MoveDetailStepState();
}

class _MoveDetailStepState extends State<MoveDetailStep> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  // Function to open the image/video picker
  Future _pickImageOrVideo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path);
      });
    }
  }

  // Widget to display the selected image or video
  Widget _displayImageOrVideo(XFile? image) {
    if (image!.path.endsWith('.mp4')) {
      // Display video
      final videoController = VideoPlayerController.file(File(image.path));
      return Container(
        width: 300, // Adjust the width as needed
        height: 200, // Adjust the height as needed
        child: VideoPlayer(videoController),
      );
    } else {
      return Container(
        width: 300, // Adjust the width as needed
        height: 200, // Adjust the height as needed
        child: Image.file(
          File(image.path),
          fit: BoxFit.cover, // You can adjust the BoxFit value as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: "Name"),
          onChanged: (value) {
            final updateName = value;
            widget.onChanged(
                updateName, widget.description, widget.difficulty.toInt());
          },
        ),
        Slider(
          value: widget.difficulty,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (value) {
            final updateDifficulty = value.toInt();
            widget.onChanged(widget.name, widget.description, updateDifficulty);
          },
        ),
        Text('Difficulty: ${widget.difficulty.toStringAsFixed(0)}'),
        TextField(
          decoration: const InputDecoration(labelText: "Description"),
          maxLines: 3,
          onChanged: (value) {
            final updateDescription = value;
            widget.onChanged(
                widget.name, updateDescription, widget.difficulty.toInt());
          },
        ),
        ElevatedButton(
          onPressed: _pickImageOrVideo,
          child: const Text("Import Image/Video"),
        ),
        image != null ? _displayImageOrVideo(image) : SizedBox(),
      ],
    );
  }
}
