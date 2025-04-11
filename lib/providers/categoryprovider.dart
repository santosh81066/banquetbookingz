import "package:banquetbookingz/models/category.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:http/http.dart' as http;
import "package:banquetbookingz/utils/banquetbookzapi.dart";
import "package:flutter/material.dart";
import 'dart:convert';
import 'package:banquetbookingz/main.dart';

class CategoryNotifier extends StateNotifier<Category> {
  CategoryNotifier() : super(Category.initial());

  // Add Category Method
  Future<void> addCategory({String? categoryName}) async {
    try {
      final url = Uri.parse(Api.addcategory);

      // Debugging prints
      print('API URL: $url');
      print('Request Headers: {"Content-Type": "application/json"}');
      print('Request Body: ${json.encode({'name': categoryName?.trim()})}');

      final data = json.encode({"name": categoryName?.trim()});
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: data,
      );

      final responseCode = response.statusCode;
      final responseBodys = response.body; // Raw response body
      final responseBody = json.decode(response.body);

      print('Response Code: $responseCode');
      print('Raw Server Response: $responseBodys');
      print('Server Response: $responseBody');

      if (responseCode == 200 || responseCode == 201) {
        print('Category added successfully: $responseBody');
        // After adding, fetch updated categories
        await getCategory();
      } else {
        throw Exception(responseBody['messages'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Error adding category: $e');
      rethrow; // Pass the error back
    }
  }

  // Get Categories Method
  Future<void> getCategory() async {
    print("Fetching category names...");

    try {
      // Ensure the correct endpoint for fetching categories is used.
      final response = await http.get(
        Uri.parse(Api.addcategory),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        print('Decoded Response: $decodedResponse');

        // Create a Category model from the response and update the state
        Category category = Category.fromJson(decodedResponse);
        state = category; // Update the state with the fetched category data

        print('Category fetched successfully: ${category.data}');
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching category: $e');
    }
  }

 Future<void> editCategory({
  String? categoryid,
  String? categoryName,
  
 }) async {
  try {
    print("apicategoryid$categoryid");
    print("apicategoryName$categoryName");
    final response = await http.patch(
      Uri.parse(Api.addcategory),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        
        'id': categoryid.toString().trim() ,
        'name': categoryName.toString().trim(),
      
      }),
    );

    final responseCode = response.statusCode;
    final responseBody = json.decode(response.body);

    print('Response Code: $responseCode');
    print('Server Response: $responseBody');

    if (responseCode == 200 || responseCode == 201) {
      print('Subscription updated successfully: $responseBody');
      await getCategory(); // Refresh state
    } else {
      throw Exception(responseBody['messages'] ?? 'Unknown error occurred');
    }
  } catch (e) {
    print('Error updating subscription: $e');
    rethrow; // Pass the error back
  }
}


  Future<void> deletecategory(String categoryid, String categoryName) async {
    print("categoryid$categoryid");
    print("categoryname$categoryName");
  try {
    final response = await http.delete(
      Uri.parse(Api.addcategory), // Use the correct DELETE API URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": categoryid,
        "name": categoryName,
      }),
    );
      final responseCode = response.statusCode;
    final responseBody = json.decode(response.body);

    print('Response Code: $responseCode');
    print('Server Response: $responseBody');


    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        // Successfully deleted
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('category deleted successfully'),
            backgroundColor: Colors.red,
          ),
        );

        // Call getCategory to refresh the state
        await getCategory();
      } else {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              responseData['messages']?.join(', ') ?? 'Error deleting category',
            ),
          ),
        );
      }
    } else {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Failed to delete category')),
      );
    }
  } catch (e) {
    print("Error deleting subscription: $e");
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


}

final categoryProvider = StateNotifierProvider<CategoryNotifier, Category>((ref) {
  return CategoryNotifier();
});
