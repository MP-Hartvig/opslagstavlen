import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opslagstavlen/bloc/photo_bloc.dart';
import 'package:opslagstavlen/event/photo_event.dart';
import 'package:opslagstavlen/model/photo.dart';
import 'package:opslagstavlen/state/photo_state.dart';
import 'package:opslagstavlen/widget/remove_add_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _file;
  Photo? photo;
  late TextEditingController descriptionController = TextEditingController();
  late List<Widget> dragTargetWidgetList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: DragTarget<Photo>(
                builder:
                    (dragContext, List<dynamic> accepted, List<dynamic> rejected) {
                  return Stack(
                    children: [...dragTargetWidgetList],
                  );
                },
                // onAccept: (data) => {data},
                onAcceptWithDetails: (details) => {
                  _setPosition(
                      details.offset.dx, details.offset.dy, details.data.image)
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: draggablePhotoList(),
            ),
          ],
        ),
        floatingActionButton: removeAddFAB(
            leftSideIcon: Icons.cancel_presentation_outlined,
            leftSideOnClick: _clearList,
            rightSideIcon: Icons.camera_alt_outlined,
            rightSideOnClick: getImage),);
  }

  void _setPosition(double dx, double dy, Uint8List img) {
    setState(() {
      positionContainer(img, dx, dy);
    });
  }

  void _clearList() {
    setState(() {
      dragTargetWidgetList = [];
    });
  }

  Future getImage() async {
    _file = await ImagePicker().pickImage(source: ImageSource.camera);

    if (_file == null) return;

    setState(() {
      _showMyDialog();
    });
  }

  List<Widget> positionContainer(Uint8List img, double dx, double dy) {
    dragTargetWidgetList.add(Positioned(
        left: dx,
        top: dy,
        child: Image.memory(
          img,
          width: 120,
          height: 120,
        )));

    return dragTargetWidgetList;
  }

  Widget draggablePhotoList() {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (BuildContext draggableContext, PhotoState state) {
        return Container(
            color: Colors.lightBlue.shade200,
            child: GridView.count(
              crossAxisCount: 2,
              children: state.photos
                  .map((Photo photo) => Draggable<Photo>(
                        data: photo,
                        feedback: Image.memory(
                          photo.image,
                          width: 120,
                          height: 120,
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Image.memory(photo.image)),
                      ))
                  .toList(),
            ));
      },
    );
  }

  void _showMyDialog() {
    final PhotoBloc photoBloc = BlocProvider.of<PhotoBloc>(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Image information'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.file(File(_file!.path)),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter description',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                photo = Photo(
                    fileName: _file!.name,
                    fileType: _file!.mimeType != null
                        ? _file!.mimeType!
                        : _file!.name.split('.').last,
                    description: descriptionController.text,
                    image: File(_file!.path).readAsBytesSync());
                photoBloc.add(PhotoCreateEvent(photo!));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
