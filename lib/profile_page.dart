import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final picker = ImagePicker();
  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    try {
      final String userEmail = FirebaseAuth.instance.currentUser!.email!;
      Reference ref = _storage.ref().child('profile_pictures').child(userEmail);

      // Get the download URL of the file
      final url = await ref.getDownloadURL();
      // Load the image from the URL
      final imageFile = await _getImageFileFromUrl(url);
      // Set the loaded image file to the _image variable
      setState(() {
        _image = imageFile;
      });
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        // Handle case where the file doesn't exist
        print('Profile picture does not exist.');
      } else {
        // Handle other Firebase exceptions
        print('Error loading profile picture: $e');
      }
    }
  }

  Future<File> _getImageFileFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/profile_image.jpg');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file;
  }

  Future<void> _uploadProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Upload image to Firebase Storage
      final String userEmail = FirebaseAuth.instance.currentUser!.email!;
      Reference ref = _storage.ref().child('profile_pictures').child(userEmail);
      await ref.putFile(_image!);
      print('Profile picture uploaded.');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey,
                  ),
                )
              : CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(_image!),
                ),
          SizedBox(height: 20),
          Text(
            user?.email ?? '',
            style: GoogleFonts.lobster(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadProfileImage,
            child: Text('Upload Profile Picture'),
          ),
        ],
      ),
    );
  }
}
