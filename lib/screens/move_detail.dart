import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MoveDetailStep extends StatefulWidget {
  final double difficulty;
  final String description;
  final String name;
  final void Function(String, String, int) onChanged;
//  final XFile? image;

  const MoveDetailStep({
    super.key,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.onChanged,
    //  required this.image,
  });

  @override
  MoveDetailStepState createState() => MoveDetailStepState();
}

class MoveDetailStepState extends State<MoveDetailStep> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  VideoPlayerController? videoController;
  // Function to open the image/video picker
  Future pickMedia() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path);
      });
    }
  }

  Future<void> captureMedia() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path);
      });
    }
  }

  // Widget to display the selected image or video
  Widget displayMedia(XFile? image) {
    if (image!.path.endsWith('.mp4')) {
      // Display video
      videoController = VideoPlayerController.file(File(image.path))
        ..initialize().then((value) {
          setState(() {});
        });
      return Container(
        width: 350,
        height: 250,
        child: videoController!.value.isInitialized
            ? VideoPlayer(videoController!)
            : Container(),
      );
    } else {
      if (!kIsWeb) {
        return SizedBox(
          width: 300,
          height: 200,
          child: Image.file(File(image.path), fit: BoxFit.cover),
        );
      } else {
        return Image.network(image.path, fit: BoxFit.cover);
      }
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickMedia();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo/Video'),
              onTap: () {
                Navigator.pop(context);
                captureMedia();
              },
            ),
          ],
        );
      },
    );
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
          onPressed: _showMediaOptions,
          child: const Text("Import media"),
        ),
        image != null ? displayMedia(image) : const SizedBox(),
      ],
    );
  }
}
