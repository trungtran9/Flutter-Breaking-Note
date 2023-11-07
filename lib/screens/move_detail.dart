import 'dart:async';

import 'package:firstapp/screens/video_trimming.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MoveDetailStep extends StatefulWidget {
  final double difficulty;
  final String description;
  final String name;
  final void Function(String, String, int, String?) onChanged;
  final void Function(bool isValid) onFormValidityChanged;
  final String path;

  const MoveDetailStep({
    super.key,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.onChanged,
    required this.onFormValidityChanged,
    required this.path,
  });

  @override
  MoveDetailStepState createState() => MoveDetailStepState();
}

class MoveDetailStepState extends State<MoveDetailStep> {
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  XFile? image;
  VideoPlayerController? videoController;
  bool _isFormValid = false;
  // Function to open the image/video picker
  Future pickMedia() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path);
      });
    }
    navigateToTrimmer();
  }

  void navigateToTrimmer() {
    if (image!.path.endsWith('.mp4')) {
      // Display video
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return TrimmerView(image!.path);
        }),
      ).then((result) {
        if (result != null) {
          setState(() {
            final path = result;
            widget.onChanged(widget.name, widget.description,
                widget.difficulty.toInt(), path);
          });
        }
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
    navigateToTrimmer();
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
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  final updateName = value;
                  widget.onChanged(updateName, widget.description,
                      widget.difficulty.toInt(), widget.path);
                  _isFormValid = _formKey.currentState!.validate();
                  widget.onFormValidityChanged(_isFormValid);
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                }),
            Slider(
              value: widget.difficulty,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                final updateDifficulty = value.toInt();
                widget.onChanged(widget.name, widget.description,
                    updateDifficulty, widget.path);
              },
            ),
            Text('Difficulty: ${widget.difficulty.toStringAsFixed(0)}'),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
              onChanged: (value) {
                final updateDescription = value;
                widget.onChanged(widget.name, updateDescription,
                    widget.difficulty.toInt(), widget.path);
              },
            ),
            ElevatedButton(
              onPressed: _showMediaOptions,
              child: const Text("Import media"),
            ),
          ],
        ));
  }
}
