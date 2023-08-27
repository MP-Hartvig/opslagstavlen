import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opslagstavlen/bloc/photo_bloc.dart';
import 'package:opslagstavlen/event/photo_event.dart';
import 'package:opslagstavlen/model/photo.dart';
import 'package:opslagstavlen/state/photo_state.dart';

class LocalStorageScreen extends StatefulWidget {
  const LocalStorageScreen({super.key});

  @override
  State<LocalStorageScreen> createState() => _LocalStorageScreenState();
}

class _LocalStorageScreenState extends State<LocalStorageScreen> {
  List<Photo> photoList = [];
  @override
  Widget build(BuildContext context) {
    PhotoBloc photoBloc = BlocProvider.of<PhotoBloc>(context);
    photoBloc.add(PhotoGetLocalListEvent());
    return Scaffold(
      body: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (BuildContext draggableContext, PhotoState state) {
            photoList = state.photos;
        return GridView.builder(
          itemCount: photoList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1),
          itemBuilder: (gridContext, int index) {
            return photoList != []
                ? Image.memory(state.photos[index].image)
                : const Center(child: Text("Local storage empty"));
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: clearLocalStorage,
          child: const Icon(Icons.delete_forever_outlined)),
    );
  }

  void clearLocalStorage() {
    PhotoBloc photoBloc = BlocProvider.of<PhotoBloc>(context);
    photoBloc.add(PhotoDeleteLocalListEvent());
    setState(() {
      photoList = [];
    });
  }
}
