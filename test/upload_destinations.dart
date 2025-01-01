import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/services/firebase_service.dart';

void main() async {
  runApp(const UploadTestApp());
}

class UploadTestApp extends StatelessWidget {
  const UploadTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String _status = 'Initializing...';
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeAndUpload();
  }

  Future<void> _initializeAndUpload() async {
    try {
      // Initialize Firebase
      setState(() => _status = 'Initializing Firebase...');
      await Firebase.initializeApp();

      // Create instance of FirebaseService
      final firebaseService = FirebaseService();

      // Upload destinations
      setState(() => _status = 'Uploading destinations...');
      await firebaseService.uploadDestinations();

      setState(() {
        _status = 'Successfully uploaded all destinations!';
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _status = 'Error: ${e.toString()}';
        _isLoading = false;
        _isError = true;
      });
      print('Error during upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Upload Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                _status,
                style: TextStyle(
                  color: _isError ? Colors.red : Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              if (!_isLoading && !_isError)
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
              if (!_isLoading && _isError)
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
              if (!_isLoading)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _isError = false;
                      _status = 'Initializing...';
                    });
                    _initializeAndUpload();
                  },
                  child: Text('Try Again'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}