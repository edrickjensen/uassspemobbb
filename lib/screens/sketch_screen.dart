import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'dashboard_screen.dart';
import '../widgets/sketch_painter.dart';

class SketchScreen extends StatefulWidget {
  const SketchScreen({super.key});

  @override
  _SketchScreenState createState() => _SketchScreenState();
}

class _SketchScreenState extends State<SketchScreen> {
  List<Offset?> _points = [];
  GlobalKey _globalKey = GlobalKey();

  Future<void> _saveToFirebase() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    File imgFile = File('${directory.path}/sketch.png');
    await imgFile.writeAsBytes(pngBytes);

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      TaskSnapshot snapshot = await storage.ref('sketches/sketch_${DateTime.now().millisecondsSinceEpoch}.png').putFile(imgFile);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('sketches').add({
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gambar diunggah: $downloadUrl")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mengunggah: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sketch & Share'),
        actions: [
          IconButton(icon: const Icon(Icons.cloud_upload), onPressed: _saveToFirebase),
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen())),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              _points.add(renderBox.globalToLocal(details.globalPosition));
            });
          },
          onPanEnd: (details) => _points.add(null),
          child: CustomPaint(painter: SketchPainter(_points), size: Size.infinite),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _points.clear()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
