import 'dart:convert';
import 'dart:ffi';
import 'dart:io' as platform;
import 'dart:io';
import 'dart:math';
import 'package:banquetbookingz/models/users.dart';
import 'package:banquetbookingz/providers/authprovider.dart';
import 'package:banquetbookingz/providers/loader.dart';
import 'package:banquetbookingz/utils/banquetbookzapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:banquetbookingz/models/authstate.dart";
import 'package:banquetbookingz/providers/imageprovider.dart';

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]);

  void setImageFile(XFile? file) {}

  Future<User?> updateUser(
  int userId,
  String username,
  String email,
  String mobile,
  File? profileImage,
  bool? userStatus,
  // bool?userRole,
  bool? admin,
  WidgetRef ref,
) async {
  final url = Uri.parse(Api.updateeuser);
  final token = await _getAccessToken();
  print("Access token: $token");

  if (token == null) {
    throw Exception('Authorization token not found');
  }

  try {
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Token $token',
        'Content-Type': 'multipart/form-data',
      })
      ..fields['id'] = userId.toString()
      ..fields['username'] = username
      ..fields['email'] = email
      ..fields['mobile_no'] = mobile
      ..fields['user_status'] = userStatus.toString();

    if (profileImage != null) {
      if (await profileImage.exists()) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_pic',
          profileImage.path,
        ));
      } else {
        print("Profile image file does not exist: ${profileImage.path}");
        throw Exception("Profile image file not found");
      }
    }

    print("Request URL: ${request.url}");
    print("Request Fields: ${request.fields}");
    print("Request Headers: ${request.headers}");

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);
    print("Update Response Body: ${responseData.body}");
    print("Response Status Code: ${responseData.statusCode}");

    if (responseData.statusCode == 200) {
      final responseJson = json.decode(responseData.body);
      print("Response nowwwwww--JSON: $responseJson");

      if (responseJson['data'] != null) {
        if (admin == true) {
            final updatedAdminAuth = AdminAuth.fromJson(responseJson);
            ref.read(authProvider.notifier).updateAdminState(updatedAdminAuth);

            final prefs = await SharedPreferences.getInstance();
            prefs.setString('userData', json.encode(updatedAdminAuth.toJson()));

            print("Updated Admin Data: $updatedAdminAuth");
          } else {
            final updatedUser = User.fromJson(responseJson['data']);
            state = [
              for (final user in state)
                if (user.userId == userId) updatedUser else user,
            ];
            print("Updated User Data: $updatedUser");
            return updatedUser;
          }
      } else {
        throw Exception('Invalid data received from server');
      }
    } else {
      final error =
          json.decode(responseData.body)['message'] ?? 'Error updating user';
      throw Exception(error);
    }
  } catch (e) {
    print('Error updating user: $e');
    rethrow;
  }
}

  void deleteUser(String userId, WidgetRef ref) async {
    final url = Uri.parse('https://www.gocodecreations.com/bbadminlogin');
    try {
      final response = await http.delete(
        Uri.parse(Api.login), // Use the correct DELETE API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // Remove the user from the state
          state =
              state.where((user) => user.userId.toString() != userId).toList();

          // Show success message
          ScaffoldMessenger.of(ref.context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(ref.context).showSnackBar(
            SnackBar(
                content: Text(responseData['messages']?.join(', ') ??
                    'Error deleting user')),
          );
        }
      } else {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Failed to delete user')),
        );
      }
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<platform.File?> getImageFile(BuildContext context) async {
    return null;
  }

  String generateRandomLetters(int length) {
    var random = Random();
    var letters = List.generate(length, (_) => random.nextInt(26) + 97);
    return String.fromCharCodes(letters);
  }

  Future<String?> _getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      print("Retrieved token: $token"); // Debug print
      return token;
    } catch (e) {
      print("Error retrieving access token: $e");
      return null;
    }
  }

  Future<UserResult> addUser(
      XFile imageFile,
      String firstName,
      String emailId,
      String mobileNo,
      String password, // Add password parameter
      WidgetRef ref) 
  async {
    var uri = Uri.parse(Api.addUser);
    final loadingState = ref.watch(loadingProvider.notifier);

    int responseCode = 0;
    String? errorMessage;

    try {
      loadingState.state = true;
      var request = http.MultipartRequest('POST', uri);

      // Add the image file to your request.
      request.files.add(
          await http.MultipartFile.fromPath('profile_pic', imageFile.path));

      // Add the other form fields to your request.
      request.fields['username'] = firstName;
      request.fields['email'] = emailId;
      request.fields['mobile_no'] = mobileNo;
      request.fields['user_role'] = 'm';
      request.fields['user_status'] = '1';
      request.fields['password'] = password; // Add password to the request

    //  send the request to adduserapi
      final send = await request.send();
      final res = await http.Response.fromStream(send);
      var userDetails = json.decode(res.body);
      var statusCode = res.statusCode;
      responseCode = statusCode;

      print("User Add statuscode: $statusCode");
      print("User Add responsebody: ${res.body}");
      
      switch (responseCode) {
        case 400:
          if (userDetails['email'] != null) {
            errorMessage = 'Email already exists';
          } else if (userDetails['username'] != null) {
            errorMessage = 'Username already exists';
          }
          break;
        default:
      }
    } catch (e) {
      loadingState.state = false;
      errorMessage = e.toString();
      print("catch: $errorMessage");
    } finally {
      loadingState.state = false;
    }

    return UserResult(responseCode, errorMessage: errorMessage);
  }

  Future<void> getUsers(WidgetRef ref) async {
    print("entered getUsers");

    try {
      // Ensure the correct endpoint for fetching users is used.
      final response = await http.get(
        Uri.parse(Api.addUser), // Use the appropriate endpoint here.
        headers: {
          'Content-Type': 'application/json',
        },
      );
     if (response.statusCode == 200) {
          var decodedResponse = json.decode(response.body);
          print('Decoded Response: $decodedResponse');

          UserResponse userResponse = UserResponse.fromJson(decodedResponse);
          print('Parsed Users: ${userResponse.data}'); // Logs the list of users
          userResponse.data?.forEach((user) {
            print(user); // Prints details of each user
          });
        // Update state with the list of users
        if (userResponse.data != null) {
          ref.read(usersProvider.notifier).setUserProfiles(userResponse.data!);
          print(userResponse.data);
        } else {
          print('No users found in response');
        }
      } else {
        print('Failed to load user profiles');
      }
    } catch (e) {
      print("Error message isthat: $e");
    }
  }

  void setUserProfiles(List<User> profiles) {
    state = profiles;
  }

  Future<void> getProfilePic(String userId, WidgetRef ref) async {
  final accessToken = ref.read(authProvider).data?.accessToken;
  print("Fetching profile picture for user ID: $userId");

  try {
    // Make the GET request to fetch the image
    final response =
        await http.get(Uri.parse('${Api.profilePic}/$userId'), headers: {
      'Authorization': 'Token $accessToken',
    });

    if (response.statusCode == 200) {
      // Since the API returns an image, handle it as binary data
      final imageBytes = response.bodyBytes;

      // Optionally encode the image as a Base64 string to store in state
      final base64Image = base64Encode(imageBytes);

      // Update the profile picture in your state using the Base64 string
      ref
          .read(usersProvider.notifier)
          .updateProfilePic(userId, base64Image);

      print("Profile picture fetched successfully.");
      // Update ImageProvider with the new profile picture
      // final imageFile = XFile.fromData(imageBytes, name: 'profile_pic.jpg');
      // ref.read(imageProvider.notifier).setProfilePic(imageFile);
    } else {
      print("Failed to load profile picture. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching profile picture: $e");
  }
}


  User? getUserById(String username) {
    return state.firstWhere(
      (user) => user.username == username,
      // returns null if no matching user is found
    );
  }

  void updateProfilePic(String userId, String? profilePicUrl) {
    // Update the user's profile picture in the state
    state = [
      for (final user in state)
        if (user.userId.toString() == userId)
          user.copyWith(profilePic: profilePicUrl)
        else
          user,
    ];
  }
}

final usersProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});

class UserResult {
  final int statusCode;
  final String? errorMessage;

  UserResult(this.statusCode, {this.errorMessage});
}
