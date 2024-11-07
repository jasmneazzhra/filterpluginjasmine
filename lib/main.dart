import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_plugin_pubdev/widget/filter_carousel.dart';
import 'package:flutter_plugin_pubdev/widget/takepicture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(
    MaterialApp(
      home: PhotoFilterCarousel(cameras: cameras),
      debugShowCheckedModeBanner: false,
    ),
  );
}
