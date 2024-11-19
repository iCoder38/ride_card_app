import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';

class FullScreenDocumentUploadPage extends StatefulWidget {
  const FullScreenDocumentUploadPage(
      {super.key, required this.strBankAccountId});
  final String strBankAccountId;
  @override
  _FullScreenDocumentUploadPageState createState() =>
      _FullScreenDocumentUploadPageState();
}

class _FullScreenDocumentUploadPageState
    extends State<FullScreenDocumentUploadPage> {
  File? _frontImage;
  File? _backImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from Gallery or Camera
  Future<void> _pickImage(ImageSource source, bool isFront) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });
    }
  }

  // Show options to pick file from Gallery or Camera
  void _showImagePicker(BuildContext context, bool isFront) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery, isFront);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera, isFront);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Upload Front and Back of ID',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showImagePicker(context, true), // For front image
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: _frontImage != null
                    ? Image.file(_frontImage!, fit: BoxFit.cover)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload, size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'Tap to upload Front of ID',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showImagePicker(context, false), // For back image
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: _backImage != null
                    ? Image.file(_backImage!, fit: BoxFit.cover)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload, size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'Tap to upload Back of ID',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const Spacer(), // Pushes the button to the bottom
            ElevatedButton(
              onPressed: () {
                // Handle the upload action here
                if (kDebugMode) {
                  print("Documents uploaded");
                }
                _uploadDocumentsToStripe();
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
              ),
              child: const Text("Upload Documents"),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle document upload to Stripe for verification
  Future<void> _uploadDocumentsToStripe() async {
    if (_frontImage == null || _backImage == null) {
      if (kDebugMode) {
        print("Both front and back images are required.");
      }
      return;
    }

    try {
      showLoadingUI(context, 'Uploading...');
      // Upload front image to Stripe
      String? frontFileId = await _uploadFileToStripe(_frontImage!);

      // Upload back image to Stripe
      String? backFileId = await _uploadFileToStripe(_backImage!);

      if (frontFileId != null && backFileId != null) {
        // Attach file IDs to the connected account for verification
        await _attachFilesToAccount(frontFileId, backFileId);
        if (kDebugMode) {
          print("Documents successfully uploaded to Stripe for verification.");
        }
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Documents successfully uploaded for verification.",
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading documents to Stripe: $e");
      }
    }
  }

// Function to upload a file to Stripe and get the file ID
  Future<String?> _uploadFileToStripe(File file) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    final url = Uri.parse('https://files.stripe.com/v1/files');

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['purpose'] = 'identity_document'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['id']; // Return the file ID
    } else {
      if (kDebugMode) {
        print("Failed to upload file to Stripe: ${response.body}");
      }
      return null;
    }
  }

  // Function to attach uploaded files to the connected account for verification
  Future<void> _attachFilesToAccount(
    String frontFileId,
    String backFileId,
  ) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    final url = Uri.parse(
        'https://api.stripe.com/v1/accounts/${widget.strBankAccountId}');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'individual[verification][document][front]': frontFileId,
        'individual[verification][document][back]': backFileId,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Document successfully attached to the account.");
      }
    } else {
      if (kDebugMode) {
        print("Failed to attach document to account: ${response.body}");
      }
    }
  }
}
