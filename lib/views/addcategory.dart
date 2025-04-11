import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banquetbookingz/providers/categoryprovider.dart';
import 'package:banquetbookingz/providers/loader.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final TextEditingController _categoryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> args;
  bool _initialized = false;
  String? categoryid;
  String? type;

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final receivedArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      args = receivedArgs ?? {};

      // Set initial values from arguments
      _categoryController.text = args['categoryName'] ?? '';
      categoryid = args['categoryid'] ?? '';
      type = args['type'] ?? '';

      print("categoryname:$_categoryController.text");
       print("categoryid:$categoryid");
        print("type:$type");

      _initialized = true;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
        backgroundColor: const Color(0xff6418c3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add Pro Category",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: "Category Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Category name is required.";
                          }
                          if (value.length < 3) {
                            return "Category name must be at least 3 characters long.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          if (type == "edit") {
                            await ref.read(categoryProvider.notifier).editCategory(
                                  categoryid: categoryid,
                                  categoryName: _categoryController.text,
                                );
                            _showSnackBar("Category edited successfully!");
                            
                            
                          } else {
                            await ref.read(categoryProvider.notifier).addCategory(
                                  categoryName: _categoryController.text,
                                );
                            _showSnackBar("Category added successfully!");
                          }
                          _categoryController.clear();
                        } catch (e) {
                          _showSnackBar("Error: $e");
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor: const Color(0xff6418c3),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      type == "edit" ? "Edit Category" : "Add Category",
                      style: const TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
