import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banquetbookingz/widgets/stackwidget.dart';
import 'package:banquetbookingz/providers/subscriptionprovider_0.dart';

class Subscription extends ConsumerStatefulWidget {
  const Subscription({super.key});

  @override
  ConsumerState<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends ConsumerState<Subscription> {
  @override
  void initState() {
    super.initState();
    // Fetch subscribers when the widget is first initialized
    Future.microtask(() {
      ref.read(subscriptionProvider.notifier).getSubscribers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StackWidget(
              text: "Subscription",
              onTap: () {
                Navigator.of(context).pushNamed("addsubscriber");
              },
            ),
            const SizedBox(height:5),
            subscriptionState.data == null || subscriptionState.data!.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subscriptionState.data!.length,
                    itemBuilder: (context, index) {
                      final plan = subscriptionState.data![index];

                      // Adjust card padding and size based on screen width
                      final isMobile = screenWidth < 600;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8.0 : 16.0,
                          vertical: isMobile ? 4.0 : 8.0,
                        ),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // // Adjust image container size for responsiveness
                                    // Center(
                                    //   child: Container(
                                    //     width: isMobile ? 60 : 80,
                                    //     height: isMobile ? 60 : 80,
                                    //     color: const Color.fromARGB(255, 224, 224, 224),
                                    //     child: const Icon(Icons.image, size: 40),
                                    //   ),
                                    // ),
                                    // Centering planName and planId
                                    // const SizedBox(height: 16),
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              plan.planName ?? "No Plan Name",
                                              style: TextStyle(
                                                fontSize: isMobile ? 26 : 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Plan ID: ${plan.planId}",
                                              style: TextStyle(
                                                fontSize: isMobile ? 14 : 16,
                                                color: const Color.fromARGB(255, 83, 81, 81),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            // Handle Edit Plan
                                          },
                                           style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xff6418c3),
                                            side: const BorderSide(
                                              color: const Color(0xff6418c3),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5), // Rounded corners
                                                            side: const BorderSide(color: Color(0xff6418c3)), // Border color
                                                          ),
                                          ),
                                          child: const Text("Edit"),
                                        ),
                                        const SizedBox(width: 8),
                                        OutlinedButton(
                                          onPressed: () {
                                            // Handle Delete Plan
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xff6418c3),
                                            side: const BorderSide(
                                              color:  Color(0xff6418c3),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5), // Rounded corners
                                                            side: const BorderSide(color: Color(0xff6418c3)), // Border color
                                                          ),
                                          ),
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ...plan.subPlans!.map((subPlan) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff6418c3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${subPlan.frequency}-months",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isMobile ? 12 : 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                     color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "Price: \$${subPlan.price}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isMobile ? 10 : 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Handle Edit Sub-plan
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                     backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        const Color(0xff6418c3),
                                                    padding:const EdgeInsets.symmetric(vertical: 6, horizontal: 3),   
                                                    shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5), // Rounded corners
                                                            side: const BorderSide(color: Color(0xff6418c3)), // Border color
                                                          ),
                                                    fixedSize: const Size(30, 20),   
                                                    textStyle: const TextStyle(
                                                        fontSize: 16, // Font size
                                                        // fontWeight: FontWeight.bold, // Font weight
                                                      ), 
                                                  ),
                                                  child: const Text("Edit"),
                                                ),
                                                const SizedBox(width: 16),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Handle Delete Sub-plan
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        const Color(0xff6418c3),
                                                    padding:const EdgeInsets.symmetric(vertical: 6, horizontal: 3),   
                                                    shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5), // Rounded corners
                                                            side: const BorderSide(color: Color(0xff6418c3)), // Border color
                                                          ),
                                                    fixedSize: const Size(30, 20),   
                                                    textStyle: const TextStyle(
                                                        fontSize: 16, // Font size
                                                        // fontWeight: FontWeight.bold, // Font weight
                                                      ),    
                                                   ),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        
                                      ),
                                    ),
                                  );
                                }).toList(),

                                 ElevatedButton(
                                                  onPressed: () {
                                                    // Handle Delete Sub-plan
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xff6418c3),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:const EdgeInsets.symmetric(vertical: 6, horizontal: 3),   
                                                    shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5), // Rounded corners
                                                            side: const BorderSide(color: Color(0xff6418c3)), // Border color
                                                          ),
                                                    fixedSize: const Size(305, 20),   
                                                    textStyle: const TextStyle(
                                                        fontSize: 16, // Font size
                                                        // fontWeight: FontWeight.bold, // Font weight
                                                      ),    
                                                   ),
                                                  child: const Text("Add subplan"),
                                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
