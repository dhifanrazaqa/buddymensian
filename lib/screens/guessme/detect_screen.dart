import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionPage extends StatefulWidget {
  @override
  _TextRecognitionPageState createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late CameraDescription _camera;
  bool _isCameraInitialized = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _camera = cameras.first;
    _cameraController = CameraController(
      _camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();
    await _initializeControllerFuture;

    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _captureImage() async {
    if (!_isCameraInitialized) return;
    try {
      await _initializeControllerFuture;
      _imageFile = await _cameraController.takePicture();
      if (_imageFile != null) {
        await _performTextRecognition();
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = XFile(pickedFile.path);
      });
      await _performTextRecognition();
    }
  }

  Future<void> _performTextRecognition() async {
    if (_imageFile == null) return;
    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    Navigator.of(context).pop(recognizedText.text);
    // _showTextRecognitionDialog(recognizedText.text);
  }

  void _showTextRecognitionDialog(String recognizedText) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TextResultPage(recognizedText: recognizedText),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? CameraPreview(_cameraController)
                : Center(child: CircularProgressIndicator()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _captureImage,
                child: Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: Icon(Icons.image),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextResultPage extends StatelessWidget {
  final String recognizedText;

  TextResultPage({required this.recognizedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recognized Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            recognizedText.isEmpty ? 'No text found' : recognizedText,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
