import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:banquetbookingz/providers/loader.dart";
import "package:banquetbookingz/providers/subscriptionprovider_0.dart";

class AddSubPlans extends ConsumerStatefulWidget {
  const AddSubPlans({super.key});

  @override
  ConsumerState<AddSubPlans> createState() => _AddSubPlansState();
}

class _AddSubPlansState extends ConsumerState<AddSubPlans> {
  final _formKey = GlobalKey<FormState>(); // Add form key for validation

  final TextEditingController frequencyControllers = TextEditingController();
  final TextEditingController subPlanControllers = TextEditingController();
  final TextEditingController bookingsControllers = TextEditingController();
  final TextEditingController pricingControllers = TextEditingController();

  String? planName;
  int? planId;

  @override
  void dispose() {
    frequencyControllers.dispose();
    subPlanControllers.dispose();
    bookingsControllers.dispose();
    pricingControllers.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch arguments using ModalRoute
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        planName = args['planName'];
        planId = args['planId'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F9), // Background color
      appBar: AppBar(
        title: const Text('Existing Plan Details'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Add Form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plan Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      hintText: planName ?? 'N/A',
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Add New Sub-Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField("Frequency", frequencyControllers,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  _buildTextField("Duration", subPlanControllers),
                  const SizedBox(height: 8),
                  _buildTextField("Bookings", bookingsControllers,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  _buildTextField("Pricing", pricingControllers,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await ref
                                  .read(subscriptionProvider.notifier)
                                  .addSubSubscriptionDetails(
                                    planId: planId!,
                                    subPlanName: subPlanControllers.text,
                                    frequency: frequencyControllers.text,
                                    numBookings: bookingsControllers.text,
                                    price: pricingControllers.text,
                                  );

                              // Clear text fields after submission
                              frequencyControllers.clear();
                              subPlanControllers.clear();
                              bookingsControllers.clear();
                              pricingControllers.clear();

                              _showSnackBar(context,
                                  "Sub-Subscription added successfully!");
                              Navigator.of(context).pop();
                            } else {
                              _showSnackBar(
                                  context, "Please fill all required fields.");
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
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "$label cannot be empty";
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
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor:message=="Please fill all required fields."?Colors.red: Colors.blue, // Customize background color
      behavior: SnackBarBehavior.floating, // Optional: Floating snack bar
    ),
  );
}
