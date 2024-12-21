import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banquetbookingz/widgets/stackwidget.dart';
import 'package:banquetbookingz/providers/subscriptionprovider_0.dart';
import "package:banquetbookingz/providers/authprovider.dart";

class Subscription extends ConsumerStatefulWidget {
  const Subscription({super.key});

  @override
  ConsumerState<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends ConsumerState<Subscription> {
  @override
  void didChangeDependencies() {
  super.didChangeDependencies();
  // Fetch subscribers when the widget is loaded
  ref.read(subscriptionProvider.notifier).getSubscribers();
}

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
         child:StackWidget(
              text: "Subscription",
              onTap: () {
                Navigator.of(context).pushNamed("addsubscriber");
              },
            ),
         ),
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            
            const SizedBox(height: 5),
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                    0.4), // Shadow color and opacity
                                spreadRadius: 8, // How much the shadow spreads
                                blurRadius: 16, // How blurry the shadow appears
                                offset: const Offset(
                                    0, 0), // Shadow position (x, y)
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                              color: const Color.fromARGB(
                                                  255, 83, 81, 81),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                               final adminData = ref.watch(authProvider).data;
                                                     Navigator.pushNamed(
                                                      context,
                                                      'editsubscriber',
                                                      arguments: {
                                                        'type' :"plan",
                                                        'planId': plan.planId,
                                                        'planName':plan.planName,
                                                        'Createdby':adminData?.userId,
                                                       
                                                      },
                                                    );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xff6418c3),
                                            side: const BorderSide(
                                              color: const Color(0xff6418c3),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // Rounded corners
                                              side: const BorderSide(
                                                  color: Color(
                                                      0xff6418c3)), // Border color
                                            ),
                                          ),
                                          child: const Text("Edit"),
                                        ),
                                        const SizedBox(width: 8),
                                       OutlinedButton(
                                          onPressed: () async {
                                            final confirmed = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text("Confirm Deletion"),
                                                content: const Text("Are you sure you want to delete this plan?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirmed == true) {
                                              await ref
                                                  .read(subscriptionProvider.notifier)
                                                  .deletesubscriber("plan", plan.planId.toString(), ref);

                                              
                                              await ref..read(subscriptionProvider.notifier).getSubscribers();    
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xff6418c3),
                                            side: const BorderSide(color: Color(0xff6418c3)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
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
                                                  "${subPlan.frequency}-${subPlan.subPlanName}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isMobile ? 12 : 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "Price: \₹${subPlan.price}",
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
                                                      final adminData = ref.watch(authProvider).data;
                                                     Navigator.pushNamed(
                                                      context,
                                                      'editsubscriber',
                                                      arguments: {
                                                        'type' :"sub_plan",
                                                        'planId':subPlan.subPlanId,
                                                        'planName':plan.planName,
                                                        'subPlanName':subPlan.subPlanName,
                                                        'frequency':subPlan.frequency,
                                                        'Createdby':adminData?.userId,
                                                        'numOfBookings':subPlan.numBookings.toString(),
                                                        'price':subPlan.price,
                                                       
                                                      },
                                                    );
                                                  
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        const Color(0xff6418c3),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 6,
                                                        horizontal: 3),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5), // Rounded corners
                                                      side: const BorderSide(
                                                          color: Color(
                                                              0xff6418c3)), // Border color
                                                    ),
                                                    fixedSize:
                                                        const Size(30, 20),
                                                    textStyle: const TextStyle(
                                                      fontSize: 16, // Font size
                                                      // fontWeight: FontWeight.bold, // Font weight
                                                    ),
                                                  ),
                                                  child: const Text("Edit"),
                                                ),
                                                const SizedBox(width: 16),
                                               ElevatedButton(
                                                  onPressed: () async {
                                                    final confirmed = await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text("Confirm Deletion"),
                                                        content: const Text("Are you sure you want to delete this sub-plan?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context, false),
                                                            child: const Text("Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context, true),
                                                            child: const Text("Delete"),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    if (confirmed == true) {
                                                       await ref
                                                       .read(subscriptionProvider.notifier)
                                                       .deletesubscriber("sub_plan", subPlan.subPlanId.toString(), ref);

                                                       await ref..read(subscriptionProvider.notifier).getSubscribers();
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    foregroundColor: const Color(0xff6418c3),
                                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5), // Rounded corners
                                                      side: const BorderSide(color: Color(0xff6418c3)), // Border color
                                                    ),
                                                    fixedSize: const Size(30, 20),
                                                    textStyle: const TextStyle(fontSize: 16), // Font size
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
                                    final subscriptionState = ref.watch(subscriptionProvider).data;
                                     Navigator.pushNamed(
                                          context,
                                          'addsubplans',
                                          arguments: {
                                            'planId': plan.planId,
                                            'planName':plan.planName,
                                            
                                          },
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff6418c3),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Rounded corners
                                      side: const BorderSide(
                                          color: Color(
                                              0xff6418c3)), // Border color
                                    ),
                                    minimumSize: const Size(double.infinity, 50),
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
