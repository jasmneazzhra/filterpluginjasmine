import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pubdev/widget/filter_selector.dart';

class TakepictureScreen extends StatefulWidget {
  const TakepictureScreen({
    Key? key,
    required this.camera,
    required this.filterColorNotifier,
  }) : super(key: key);

  final CameraDescription camera;
  final ValueNotifier<Color> filterColorNotifier;

  @override
  TakepictureScreenState createState() => TakepictureScreenState();
}

class TakepictureScreenState extends State<TakepictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final List<Color> _filters = [
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture - NIM Anda')),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Pratinjau kamera
                CameraPreview(_controller),
                // Overlay filter warna pada pratinjau kamera
                ValueListenableBuilder<Color>(
                  valueListenable: widget.filterColorNotifier,
                  builder: (context, color, child) {
                    return Container(
                      color: color.withOpacity(0.5),
                    );
                  },
                ),
                // FilterSelector untuk memilih filter
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FilterSelector(
                    filters: _filters,
                    onFilterChanged: (color) {
                      widget.filterColorNotifier.value = color;
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            // Navigator.pop(context, image.path); // Ganti dengan logika untuk menyimpan gambar
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
