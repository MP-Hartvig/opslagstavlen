// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
// import 'package:opslagstavlen/model/photo.dart';
// import 'package:opslagstavlen/state/photo_state.dart';
// import 'package:opslagstavlen/widget/remove_add_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opslagstavlen/bloc/photo_bloc.dart';
import 'package:opslagstavlen/event/photo_event.dart';
import 'package:opslagstavlen/locator/photo_locator.dart';
import 'package:opslagstavlen/screens/home_screen.dart';
import 'package:opslagstavlen/screens/local_storage_screen.dart';

void main() {
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PhotoBloc>(create: (context) => PhotoBloc()),
        ],
        child: const PhotoGrid(),
      ),
    );
  }
}

class PhotoGrid extends StatefulWidget {
  const PhotoGrid({Key? key}) : super(key: key);

  @override
  PhotoGridState createState() => PhotoGridState();
}

class PhotoGridState extends State<PhotoGrid> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  void _toggleDrawer() async {
    if (scaffoldState.currentState != null) {
      if (scaffoldState.currentState!.isDrawerOpen) {
        scaffoldState.currentState!.openEndDrawer();
      } else {
        scaffoldState.currentState!.openDrawer();
      }
    }
  }

  void _menuChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final PhotoBloc photoBloc = BlocProvider.of<PhotoBloc>(context);
    photoBloc.add(PhotoGetListEvent());

    List<Widget> views = <Widget>[
      const HomeScreen(),
      const LocalStorageScreen()
    ];

    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(title: const Text("Image canvas")),
      body: SafeArea(
        child: views[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Menu"),
            ),
            ListTile(
              title: const Text("Home screen"),
              selected: _selectedIndex == 0,
              onTap: () {
                _toggleDrawer();
                _menuChange(0);
              },
            ),
            ListTile(
              title: const Text("Local storage"),
              selected: _selectedIndex == 1,
              onTap: () {
                _toggleDrawer();
                _menuChange(1);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
