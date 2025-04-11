import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banquetbookingz/widgets/stackwidget.dart';
import 'package:banquetbookingz/providers/categoryprovider.dart';
import 'package:banquetbookingz/models/category.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    ref.read(categoryProvider.notifier).getCategory();
  }
  @override
  Widget build(BuildContext context) {
    // Watch the category state to get the data
    final category = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: StackWidget(
          text: "Category",
          onTap: () {
            Navigator.of(context).pushNamed("addcategory");
          },
        ),
      ),
      body: category.statusCode == 0
          ? const Center(child: CircularProgressIndicator())
          : (category.data != null && category.data!.isNotEmpty)
              ? ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: category.data!.length,
                  itemBuilder: (context, index) {
                    final categoryData = category.data![index];

                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          categoryData.name ?? 'No name available',
                          style: const TextStyle(
                            color: Color(0xFF6418C3),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit Icon
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  'addcategory',
                                  arguments: {
                                    'categoryid':categoryData.id.toString(),
                                    'categoryName': categoryData.name,
                                    'type':"edit",
                                    },
                                );
                              },
                            ),
                            // Delete Icon
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Deletion"),
                                      content: Text(
                                          "Are you sure you want to delete '${categoryData.name}'?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close dialog
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                              final notifier = ref.read(categoryProvider.notifier);

                                              // Save context in a local variable before closing the dialog
                                              // final dialogContext = context;

                                              // Close the dialog first
                                              Navigator.of(context).pop();

                                              // Perform the delete operation after the dialog is closed
                                              await notifier.deletecategory(
                                                categoryData.id.toString(),
                                                categoryData.name?? '',
                                              //  ScaffoldMessenger.of(context).context, // Use the context tied to the Scaffold
                                              );
                                            },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text("No categories found")),
    );
  }
}
