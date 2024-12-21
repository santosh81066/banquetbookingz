import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/authprovider.dart';
import '../providers/bottomnavigationbarprovider.dart';
import '../providers/searchtextnotifier.dart';

class StackWidget extends StatelessWidget {
  final String? hintText;
  final IconData? arrow;
  final String text;
  final VoidCallback? onTap;
  final VoidCallback? tabArrow;
  final TextEditingController? textEditingController;

  const StackWidget({
    super.key,
    this.hintText,
    this.arrow,
    required this.text,
    this.onTap,
    this.tabArrow,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer(
      builder: (context, ref, child) {
        final selectedIndex = ref.watch(pageIndexProvider);
        final usertype = ref.watch(authProvider);

        return Stack(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.10,
                  width: screenWidth,
                  color: const Color(0xFFFFFFFF), // Set background color to white
                ),
              ],
            ),
            Positioned(
              child: Stack(
                children: [
                  Container(
                    height: screenHeight * 0.22,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  selectedIndex != 3 && usertype.data?.userRole=='a'
                      ? Positioned(
                          top: 50,
                          right: 20,
                          child: InkWell(
                            onTap: onTap,
                            child: selectedIndex == 2
                                ? const Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                : Stack(
                                    alignment: Alignment.bottomRight,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                        size: 50.0,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.purple,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.local_police_sharp,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        )
                      : Container(),
                    // Conditionally hide the TextField if the text is "Subscription"
                  text != "Subscription"
                      ?Positioned(
                    bottom: 0,
                    left: 10,
                    right: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: screenWidth * 0.85,
                        child: TextField(
                          controller: textEditingController,
                          onChanged: (value) {
                            ref.read(searchTextProvider.notifier).setSearchText(value);
                            print('Search text updated: $value'); // Debug print
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: hintText,
                            prefixIcon: const Icon(Icons.search, color: Color(0xff6418c3)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ):Container(),// Empty container to hide the TextField
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
