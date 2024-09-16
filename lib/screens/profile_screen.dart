import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = selectedImage;
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri parsedUrl = Uri.parse(url);

    if (await canLaunchUrl(parsedUrl)) {
      await launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Imagen de perfil
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade300,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : const AssetImage('assets/kaito.png')
                            as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Nombre completo
              const ListTile(
                leading: Icon(Icons.person_2_rounded, color: Colors.brown),
                title: Text('Nombre completo',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Jair Velazquez Reyes'),
              ),
              // Correo electronico
              ListTile(
                leading: const Icon(Icons.email, color: Colors.orange),
                title: const Text('Correo'),
                subtitle: const Text('20030039@itcelaya.edu.mx'),
                onTap: () => _launchURL(
                    'mailto:20030039@itcelaya.edu.mx?subject=News&body=New%20plugin'),
              ),
              // Teléfono
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: const Text('Teléfono'),
                subtitle: const Text('+524611166092'),
                onTap: () => _launchURL('tel:+52-461-116-60-92'),
              ),
              // GitHub
              ListTile(
                leading: const Icon(Icons.web, color: Colors.green),
                title: const Text('GitHub'),
                subtitle: const Text('https://github.com/jairvelaz54'),
                onTap: () => _launchURL('https://github.com/jairvelaz54'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
