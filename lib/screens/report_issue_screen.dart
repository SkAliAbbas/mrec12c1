import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../models/issue_model.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _imageFile;
  double? lat, long;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Report Issue")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title")),
            TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 10),
            _imageFile != null
                ? Image.file(_imageFile!, height: 150)
                : Container(),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
              child: const Text("Pick Image"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (lat != null && long != null) {
                  final issue = Issue(
                    id: const Uuid().v4(),
                    title: _titleController.text,
                    description: _descController.text,
                    imageUrl: '',
                    latitude: lat!,
                    longitude: long!,
                  );
                  await firebaseService.reportIssue(issue, _imageFile);
                  Navigator.pop(context);
                }
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
