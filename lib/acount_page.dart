import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'language_provider.dart';

class AcountPage extends StatefulWidget {
  final String userId;
  const AcountPage({required this.userId});
  @override
  State<AcountPage> createState() => AcountPageState();
}

class AcountPageState extends State<AcountPage> {
  String? userName, userPhone, userEmail, imageUrl;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() => isLoading = true);
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (doc.exists) {
      setState(() {
        userName = doc['name'];
        userPhone = doc['phone'];
        userEmail = doc['email'];
        imageUrl = doc['imageUrl'];
      });
    }
    setState(() => isLoading = false);
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => isLoading = true);
      File file = File(pickedFile.path);
      String cloudName = "ddhzqotws";
      String uploadPreset = "shopping_app";
      var uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      var request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['upload_preset'] = uploadPreset;
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonResponse = jsonDecode(responseString);
        String downloadUrl = jsonResponse['secure_url'];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({'imageUrl': downloadUrl});
        setState(() {
          imageUrl = downloadUrl;
          isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("The image was uploaded")));
        print("تم الرفع بنجاح");
      } else {
        print("فشل الرفع");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> deleteProfileImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'imageUrl': ''});
      setState(() {
        imageUrl = '';
        isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile Image Deleted")));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          lang.translate('حسابي', 'Account'),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.perm_device_information_rounded,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 150,
                    backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!)
                        : AssetImage("images/user.jpg") as ImageProvider,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: uploadImage,
                    icon: Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 25,
                    ),
                    label: Text(
                      lang.translate(
                        'اختيار صورة شخصية',
                        'Set Profile Picture',
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  if (imageUrl != null && imageUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: deleteProfileImage,
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 25,
                        ),
                        label: Text(
                          lang.translate(
                            'حذف الصورة الشخصية',
                            "Remove Profile Picture",
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ListTile(
                    title: Text(
                      lang.translate('الاسم', "Name"),
                      style: TextStyle(fontSize: 25),
                    ),
                    subtitle: Text(
                      userName ?? lang.translate('لم يحدد', "not Set"),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    leading: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  ListTile(
                    title: Text(
                      lang.translate('الرقم', "Phone"),
                      style: TextStyle(fontSize: 25),
                    ),
                    subtitle: Text(
                      userPhone ?? lang.translate('لم يحدد', "not Set"),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    leading: Icon(Icons.phone, size: 40, color: Colors.blue),
                  ),
                  ListTile(
                    title: Text(
                      lang.translate('الايميل', "Email"),
                      style: TextStyle(fontSize: 25),
                    ),
                    subtitle: Text(
                      userEmail ?? lang.translate('لم يحدد', "not Set"),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    leading: Icon(Icons.email, size: 40, color: Colors.blue),
                  ),
                ],
              ),
      ),
    );
  }
}
