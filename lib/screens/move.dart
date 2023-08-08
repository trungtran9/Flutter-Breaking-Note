import 'dart:io';

import 'package:flutter/material.dart';

import '../models/breakdance_move.dart';
import '../utils/shared_preference_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MovesTab extends StatefulWidget {
  // final List<MoveModel> moves;
  // final Function(MoveModel) addMove;
  // final Function(String) addCategory;

  @override
  _MovesTabState createState() => _MovesTabState();
}

class _MovesTabState extends State<MovesTab> {
  List<BreakdanceMove> moves = [];

  @override
  void initState() {
    super.initState();
    loadMoves();
  }

  void loadMoves() async {
    List<BreakdanceMove> savedMoves = await SharedPreferencesHelper.getMoves();
    setState(() {
      moves = savedMoves;
    });
  }

  void _editMove(BreakdanceMove move) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddMovePopup(
        moves: moves,
        editMove: move,
      ),
    ).then((editedMove) {
      if (editedMove != null) {
        if (editedMove.dateCreated != null) {
          _handleMoveEdit(editedMove);
        } else {
          _handleMoveAdd(editedMove);
        }
      }
    });
  }

  void _handleMoveAdd(BreakdanceMove newMove) {
    List<BreakdanceMove> updatedMoves = [...moves, newMove];
    SharedPreferencesHelper.saveMoves(updatedMoves);
    setState(() {
      moves = updatedMoves;
    });
  }

  void _handleMoveEdit(BreakdanceMove editedMove) {
    List<BreakdanceMove> updatedMoves = [...moves];
    int moveIndex = updatedMoves
        .indexWhere((move) => move.dateCreated == editedMove.dateCreated);
    if (moveIndex != -1) {
      updatedMoves[moveIndex] = editedMove;
      SharedPreferencesHelper.saveMoves(updatedMoves);
      setState(() {
        moves = updatedMoves;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group the moves by category
    Map<String, List<BreakdanceMove>> movesByCategory = {};
    for (var move in moves) {
      movesByCategory.putIfAbsent(move.category, () => []);
      movesByCategory[move.category]!.add(move);
    }

    // Sort the categories in ascending order
    List<String> sortedCategories = movesByCategory.keys.toList();
    sortedCategories.sort();

    return Scaffold(
      appBar: AppBar(
        title: Text("Moves"),
      ),
      body: ListView.builder(
        itemCount: sortedCategories.length,
        itemBuilder: (context, index) {
          var category = sortedCategories[index];
          var movesInCategory = movesByCategory[category]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: movesInCategory.map((move) {
                  return GestureDetector(
                    onTap: () {
                      _editMove(move);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 -
                          20, // Adjust the width to fit 2 columns
                      padding: const EdgeInsets.all(
                          16.0), // Increase the padding for bigger buttons
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            move.name,
                            style: TextStyle(
                              fontSize: 18, // Increase font size for move name
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Difficulty: ${move.difficulty}",
                            style: TextStyle(
                              fontSize: 14, // Increase font size for difficulty
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddMovePopup(
              moves: moves,
            ),
          ).then((addedMove) {
            if (addedMove != null) {
              _handleMoveAdd(addedMove);
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddMovePopup extends StatefulWidget {
  final List<BreakdanceMove> moves;
  final BreakdanceMove? editMove;

  AddMovePopup({required this.moves, this.editMove});

  @override
  _AddMovePopupState createState() => _AddMovePopupState();
}

class _AddMovePopupState extends State<AddMovePopup> {
  String name = "";
  String description = "";
  String category = "";
  int difficulty = 1;
  VideoPlayerController? _videoController;
  final ImagePicker _imagePicker = ImagePicker();
  final _videoPlayerKey = GlobalKey();
  bool _isVideoRecording = false;
  bool _isVideoPlaying = false;

  List<String> categories = ["Category 1", "Category 2", "Category 3"];
  List<BreakdanceMove> moves = [];

  @override
  void initState() {
    super.initState();
    loadMoves();
    if (widget.editMove != null) {
      name = widget.editMove!.name;
      description = widget.editMove!.description ?? "";
      category = widget.editMove!.category;
      difficulty = widget.editMove!.difficulty;
    } else {
      category = categories[0];
    }
  }

  @override
  void dispose() {
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  void loadMoves() async {
    List<BreakdanceMove> savedMoves = await SharedPreferencesHelper.getMoves();
    setState(() {
      moves = savedMoves;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.editMove == null ? "Add New Move" : "Edit Move";
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Name"),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Description (Optional)"),
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
          ),
          DropdownButton<String>(
            // Change this to DropdownButton
            value: category,
            items: categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                category = value!;
              });
            },
            hint: Text("Select Category"), // Add a hint text for the dropdown
          ),
          Slider(
            value: difficulty.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (value) {
              setState(() {
                difficulty = value.toInt();
              });
            },
            label: "Difficulty: $difficulty",
          ),
          Container(
            key: _videoPlayerKey,
            width: 300,
            height: 200,
            child: _videoController != null &&
                    _videoController!.value.isInitialized
                ? VideoPlayer(_videoController!)
                : Container(),
          ),
          ElevatedButton(
            onPressed: _isVideoPlaying ? _stopVideo : _playVideo,
            child: Text(_isVideoPlaying ? "Stop" : "Play"),
          ),
          ElevatedButton(
            onPressed: _isVideoRecording
                ? _stopRecordingVideo
                : _showMediaSourceDialog,
            child: Text(_isVideoRecording ? "Stop Recording" : "Choose Media"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            BreakdanceMove move = BreakdanceMove(
              name: name,
              description: description,
              category: category,
              difficulty: difficulty,
              dateCreated: widget.editMove?.dateCreated ?? DateTime.now(),
            );

            if (widget.editMove != null) {
              // If editing an existing move, pass the edited move back to the parent widget
              Navigator.of(context).pop(move);
            } else {
              // If adding a new move, create a new list with old moves and the new move
              List<BreakdanceMove> updatedMoves = [...moves, move];
              SharedPreferencesHelper.saveMoves(updatedMoves);
              // setState(() { // We don't need to set state here for adding new moves
              //   moves = updatedMoves;
              // });
              Navigator.of(context)
                  .pop(move); // Pass the new move back to the parent widget
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }

  void _playVideo() {
    if (_videoController != null) {
      setState(() {
        _isVideoPlaying = true;
      });
      _videoController!.play().whenComplete(() {
        setState(() {
          _isVideoPlaying = false;
        });
      });
    }
  }

  void _stopVideo() {
    if (_videoController != null) {
      _videoController!.pause();
      setState(() {
        _isVideoPlaying = false;
      });
    }
  }

  Future<void> _startRecordingVideo() async {
    try {
      XFile? recordedVideo =
          await _imagePicker.pickVideo(source: ImageSource.camera);

      if (recordedVideo != null) {
        _videoController = VideoPlayerController.file(File(recordedVideo.path))
          ..addListener(() => setState(() {}))
          ..initialize().then((_) {
            _videoController!.setLooping(true);
            _videoController!.play();
            setState(() {
              _isVideoRecording = true;
            });
          });
      }
    } catch (e) {
      print("Error recording video: $e");
    }
  }

  Future<void> _showMediaSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose Media Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _pickMedia(ImageSource.gallery);
                  Navigator.of(context)
                      .pop(); // Close the dialog after choosing
                },
                child: Text("Pick from Gallery"),
              ),
              ElevatedButton(
                onPressed: () {
                  _pickMedia(ImageSource.camera);
                  Navigator.of(context)
                      .pop(); // Close the dialog after choosing
                },
                child: Text("Capture from Camera"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedia(ImageSource source) async {
    try {
      XFile? pickedMedia = await _imagePicker.pickVideo(source: source);

      if (pickedMedia != null) {
        _videoController = VideoPlayerController.file(File(pickedMedia.path))
          ..addListener(() => setState(() {}))
          ..initialize().then((_) {
            _videoController!.setLooping(true);
            _videoController!.play();
            setState(() {
              _isVideoRecording = false;
            });
          });
      }
    } catch (e) {
      print("Error picking media: $e");
    }
  }

  void _stopRecordingVideo() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.pause();
      _videoController!.dispose();
    }

    setState(() {
      _isVideoRecording = false;
    });
  }
}
