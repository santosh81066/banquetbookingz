import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/usersprovider.dart';
import "../utils/banquetbookzapi.dart";

class EditUser extends ConsumerStatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  EditUserState createState() => EditUserState();
}

class EditUserState extends ConsumerState<EditUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _isLoading = false;
  late Map<String, dynamic> args;
  bool _initialized = false;
  String? _profilePicUrl; // Store the URL of the current profile picture
  File? _profileImage; // For locally picked images
  bool? admin;
  bool? userStatus; // User status (active/inactive)
  // bool _isSwitched = false; // State for the toggle switch
  String? userRole; // User role variable
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final receivedArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (receivedArgs != null) {
        args = receivedArgs;

        // Set initial values from arguments
        _nameController.text = args['username'] ?? '';
        _emailController.text = args['email'] ?? '';
        _mobileController.text = args['mobileNo'] ?? '';
        userRole = args['userRole'] ;
        userStatus=args['userStatus'];
        admin=args["admin"];

        // Construct the profile picture URL from the userId
        final userId = args['userid'];
        if (userId != null) {
          _profilePicUrl = '${Api.profilePic}/$userId';
          }
      } else {
        _showAlertDialog('Error', 'Invalid arguments passed.');
      }
      _initialized = true;
    }
  }

  void _showConfirmationDialog(bool newValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Status Change'),
          content: Text(
            newValue
                ? 'Do you want to activate this user?'
                : 'Do you want to deactivate this user?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // _isSwitched = newValue; // Update the switch state
                  userStatus = newValue; // Update userStatus
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);// Update the locally picked image
          _profilePicUrl = null; // Clear the URL to prioritize the local file
        });
      }
    } catch (e) {
      _showAlertDialog('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final userId = args['userid'];
    if (userId == null) {
      _showAlertDialog('Error', 'User ID is missing.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userNotifier = ref.read(usersProvider.notifier);

      await userNotifier.updateUser(
        userId,
        _nameController.text,
        _emailController.text,
        _mobileController.text,
        _profileImage,// Pass the picked image file (if available)
        userStatus,
        admin,
        ref,
      );

      _showAlertDialog('Success', 'User updated successfully!');
    } catch (e) {
      _showAlertDialog('Error', 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (title == 'Success') {
                Navigator.of(context).pushReplacementNamed('users');
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profilePic = args['profilePic'];
    print("userstaus------$userStatus");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0XFF6418C3)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xfff5f5f5),
        title: const Text(
          "Edit User",
          style: TextStyle(color: Color(0XFF6418C3), fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
             
            children: [
              // Profile Picture Section
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Profile Photo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        if (userRole == "v" || userRole == "m")
                          Switch(
                            value: userStatus ?? false, // Reflect current status
                                  onChanged: (value) {
                                    _showConfirmationDialog(value); // Show confirmation popup
                                  },
                                  activeColor: const Color(0XFF6418C3),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _showImageSourceSelector(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFb0b0b0), width: 2),
                              borderRadius: BorderRadius.circular(75),
                            ),
                            width: 150,
                            height: 150,
                            child: _profileImage != null
                                ? Image.file(_profileImage!, fit: BoxFit.cover)
                                : (_profilePicUrl != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(_profilePicUrl!),
                                        radius: 75,
                                      )
                                    : const Icon(Icons.person, size: 120)),
                          ),
                          if (_isLoading) const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "User Name",
                    hintText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email ID",
                    hintText: "Email Address",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    hintText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _saveUser(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: const Color(0XFF6418C3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
