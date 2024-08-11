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
      ResolutionPreset.high,
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

  Future<void> _performTextRecognition() async {
    if (_imageFile == null) return;
    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    Navigator.of(context).pop(recognizedText.text);
    // _showTextRecognitionDialog(recognizedText.text);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _isCameraInitialized
                ? CameraPreview(_cameraController)
                : Center(child: CircularProgressIndicator()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Padding di sekitar floating button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16)
                  ),
                  onPressed: _captureImage,
                  child: Icon(Icons.camera_alt, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
