import 'package:banquetbookingz/models/subscriptionmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banquetbookingz/utils/banquetbookzapi.dart';
import 'package:banquetbookingz/providers/loader.dart';
import "package:flutter/material.dart";

class SubscriptionNotifier extends StateNotifier<Subscription> {
  final Ref ref;
  SubscriptionNotifier(this.ref) : super(Subscription.initial());

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

  /// Add a new subscription and refresh state
  Future<void> postSubscriptionDetails({
    required String planName,
    required String userId,
    required String frequency,
    required String subPlanName,
    required String numBookings,
    required String price,
  }) async {
    final uri = Uri.parse(Api.subscriptions);

    // Validate fields
    if (planName.isEmpty ||
        userId.isEmpty ||
        frequency.isEmpty ||
        subPlanName.isEmpty ||
        numBookings.isEmpty ||
        price.isEmpty) {
      print('Validation Error: All fields must be provided.');
      return;
    }

    // Convert fields to appropriate types
    final parsedFrequency = int.tryParse(frequency);
    final parsedNumBookings = int.tryParse(numBookings);
    final parsedPrice = int.tryParse(price);

    if (parsedFrequency == null || parsedNumBookings == null || parsedPrice == null) {
      print('Validation Error: Numeric fields must contain valid numbers.');
      return;
    }

    ref.read(loadingProvider.notifier).state = true; // Set loading to true
    try {
      // Prepare the multipart request
      var request = http.MultipartRequest('POST', uri);

      request.fields['plan_name'] = planName.trim();
      request.fields['created_by'] = userId.trim();
      request.fields['frequency'] = parsedFrequency.toString();
      request.fields['sub_plan_name'] = subPlanName.trim();
      request.fields['num_bookings'] = parsedNumBookings.toString();
      request.fields['price'] = parsedPrice.toString();

      // Send the request
      final send = await request.send();
      final res = await http.Response.fromStream(send);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseJson = json.decode(res.body);
        print('Subscription added successfully: $responseJson');

        // Refresh data after successfully adding a subscription
        await getSubscribers();
      } else {
        print('Error in request: ${res.statusCode}, ${res.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      ref.read(loadingProvider.notifier).state = false; // Reset loading
    }
  }


 Future<void> addSubSubscriptionDetails({
    required int? planId,
    required String subPlanName,
    required String frequency,
    required String numBookings,
    required String price,
  }) async {
    final uri = Uri.parse(Api.subSubscriptions);

    // Validate fields
    if (
        planId == null ||
        frequency.isEmpty ||
        subPlanName.isEmpty ||
        numBookings.isEmpty ||
        price.isEmpty) {
      print('Validation Error: All fields must be provided.');
      return;
    }

    // Convert fields to appropriate types
    final parsedFrequency = int.tryParse(frequency);
    final parsedNumBookings = int.tryParse(numBookings);
    final parsedPrice = int.tryParse(price);

    if (parsedFrequency == null || parsedNumBookings == null || parsedPrice == null) {
      print('Validation Error: Numeric fields must contain valid numbers.');
      return;
    }

    ref.read(loadingProvider.notifier).state = true; // Set loading to true
    try {
      // Prepare the multipart request
      var request = http.MultipartRequest('POST', uri);

      
      request.fields['plan_id'] = planId.toString();
      request.fields['sub_plan_name'] = subPlanName.trim();
      request.fields['frequency'] = parsedFrequency.toString();
      request.fields['num_bookings'] = parsedNumBookings.toString();
      request.fields['price'] = parsedPrice.toString();

      // Send the request
      final send = await request.send();
      final res = await http.Response.fromStream(send);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseJson = json.decode(res.body);
        print('Subscription added successfully: $responseJson');

        // Refresh data after successfully adding a subscription
        await getSubscribers();
      } else {
        print('Error in request: ${res.statusCode}, ${res.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      ref.read(loadingProvider.notifier).state = false; // Reset loading
    }
  }

  
Future<void> editSubscriptionDetails({
  String? type,
  int? planId,
  String? planName,
  int? userId,
  String? frequency,
  String? numBookings,
  String? price,
}) async {
  try {
    final response = await http.patch(
      Uri.parse(Api.subscriptions),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': type,
        'plan_id': planId.toString().trim() ,
        'plan_name': planName.toString().trim(),
        'created_by': userId.toString().trim(),
        'frequency': frequency.toString().trim(),
        'num_bookings': numBookings.toString().trim(),
        'price': price.toString().trim(),
      }),
    );

    final responseCode = response.statusCode;
    final responseBody = json.decode(response.body);

    print('Response Code: $responseCode');
    print('Server Response: $responseBody');

    if (responseCode == 200 || responseCode == 201) {
      print('Subscription updated successfully: $responseBody');
      await getSubscribers(); // Refresh state
    } else {
      throw Exception(responseBody['messages'] ?? 'Unknown error occurred');
    }
  } catch (e) {
    print('Error updating subscription: $e');
    rethrow; // Pass the error back
  }
}



   Future<void> deletesubscriber(String type, String planId, WidgetRef ref) async {
  try {
    final response = await http.delete(
      Uri.parse(Api.subscriptions), // Use the correct DELETE API URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': type,
        'plan_id': planId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        // Successfully deleted
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Subscription deleted successfully'),backgroundColor: Colors.red,),
        );

        // Call getSubscribers to refresh the state
        await getSubscribers();
      } else {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['messages']?.join(', ') ?? 'Error deleting subscription',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(content: Text('Failed to delete subscription')),
      );
    }
  } catch (e) {
    print("Error deleting subscription: $e");
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  /// Fetch subscribers and update the state
  Future<void> getSubscribers() async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      print("Access token is null.");
      return;
    }

    ref.read(loadingProvider.notifier).state = true; // Set loading to true
    try {
      final response = await http.get(
        Uri.parse(Api.subscriptions),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        final subscriptionData = Subscription.fromJson(res);
        state = subscriptionData; // Update state with fetched data
        print("Subscribers fetched successfully: $subscriptionData");
      } else {
        final res = json.decode(response.body);
        print(
          'Error fetching subscribers: ${res['messages']?.first ?? 'An unknown error occurred.'}',
        );
      }
    } catch (e) {
      print("Error fetching subscribers: $e");
    } finally {
      ref.read(loadingProvider.notifier).state = false; // Reset loading
    }
  }
}

/// Provider to manage loading state and API calls
final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, Subscription>((ref) {
  return SubscriptionNotifier(ref);
});
