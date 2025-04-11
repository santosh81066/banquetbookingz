import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/authprovider.dart';
import '../providers/subscriptionprovider_0.dart';
import 'package:banquetbookingz/providers/loader.dart';


class AddSubscriber extends ConsumerStatefulWidget {
  const AddSubscriber({super.key});

  @override
  ConsumerState<AddSubscriber> createState() => _AddSubscriberState();
}

class _AddSubscriberState extends ConsumerState<AddSubscriber> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  final TextEditingController planController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController subPlanController = TextEditingController();
  final TextEditingController bookingsController = TextEditingController();
  final TextEditingController pricingController = TextEditingController();

  String? selectedDuration; // To store the selected dropdown value

  final List<String> durations = ["Monthly", "Daily", "Yearly"]; // Dropdown options

  @override
  void dispose() {
    planController.dispose();
    frequencyController.dispose();
    subPlanController.dispose();
    bookingsController.dispose();
    pricingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider);
    final userId = currentUser.data?.userId ?? '';
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        color: const Color(0xFFf5f5f5),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              children: [
                AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xff6418c3),
                    ),
                  ),
                  backgroundColor: const Color(0xfff5f5f5),
                  title: const Text(
                    "Subscription",
                    style: TextStyle(color: Color(0xff6418c3), fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Subscription details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 18),
                    _buildTextField("Plan", planController),
                    const SizedBox(height: 10),
                    _buildTextField("Frequency", frequencyController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildDropdownField(), // Replace the "Duration" text field
                    const SizedBox(height: 10),
                    _buildTextField("Bookings", bookingsController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField("Pricing", pricingController,
                        keyboardType: TextInputType.number),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await ref
                                .read(subscriptionProvider.notifier)
                                .postSubscriptionDetails(
                                  planName: planController.text,
                                  userId: '$userId',
                                  frequency: frequencyController.text,
                                  subPlanName: selectedDuration ?? "",
                                  numBookings: bookingsController.text,
                                  price: pricingController.text,
                                );

                            // Clear text fields after submission
                            planController.clear();
                            frequencyController.clear();
                           
                            bookingsController.clear();
                            pricingController.clear();
                             setState(() {
                              selectedDuration = null;
                            });

                            _showSnackBar(
                                context, "Subscription added successfully!");
                            Navigator.of(context).pop();
                          } else {
                            _showSnackBar(context, "Please fill all fields.");
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF6418C3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Add Subscriber"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "$label cannot be empty"; // Validation message
            }
            if (keyboardType == TextInputType.number &&
                int.tryParse(value) == null) {
              return "$label must be a valid number";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Duration", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedDuration,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Add inner padding
          ),
          hint: const Text("Select Duration"),
          items: durations.map((String duration) {
            return DropdownMenuItem<String>(
              value: duration,
              child: Text(duration),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedDuration = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a duration";
            }
            return null;
          },
        ),
      ],
    );
  }


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message=="Please fill all fields."? Colors.red: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
