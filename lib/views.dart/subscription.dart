// import 'dart:io';
// import 'package:banquetbookingz/providers/bottomnavigationbarprovider.dart';
// import 'package:banquetbookingz/providers/getsubscribers.dart';
// import 'package:banquetbookingz/providers/selectionmodal.dart';
// import 'package:banquetbookingz/providers/subcsribersprovider.dart';
// import 'package:banquetbookingz/views.dart/addsubscriber.dart';
// import 'package:banquetbookingz/widgets/stackwidget.dart';
// import 'package:banquetbookingz/widgets/substack.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class Subscription extends ConsumerStatefulWidget {
//   const Subscription({super.key});

//   @override
//   ConsumerState<Subscription> createState() => _SubscriptionState();
// }

// class _SubscriptionState extends ConsumerState<Subscription> {
//   @override
//   void initState() {
//     super.initState();
//     // Call getUsers() when the widget is inserted into the widget tree
//     ref.read(subscribersProvider.notifier).getSubscribers();
//     // ref.read(getUserProvider.notifier).getProfilePic();
//     // Future.microtask(() {
//     //   // Get the ID passed via arguments

//     //   final id = ModalRoute.of(context)?.settings.arguments as int?;
//     //   print(id);
//     //   final ids=ref.read(selectionModelProvider).index;
//     //   print(ids);
//     //   // Get user details from your state notifier
//     //   final user = ref.read(getUserProvider.notifier).getUserById(ids!);

//     //   if (user != null) {
//     //     // Update the controllers with the user's data
//     //     ref.read(selectionModelProvider.notifier).updateEnteredemail(user.emailId ?? '');
//     //     ref.read(selectionModelProvider.notifier).updateEnteredName(user.firstName ?? '');
//     //   //    if (user.profilepic != null) {
//     //   //   ref.read(imageProvider.notifier).setProfilePic(XFile(user.profilepic!));
//     //   // }
//     //     // ... do the same for other fields
//     //   }
//     // });
//   }

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     List<bool> isSelected = [true, false, false, false];
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final usersData = ref.watch(subscribersProvider);

//     return Scaffold(
//       body: Consumer(builder: (context, ref, child) {
//         final _selectedIndex = ref.watch(pageIndexProvider);
//         final selection = ref.watch(selectionModelProvider.notifier);
//         final user = ref.watch(selectionModelProvider);
//         return SingleChildScrollView(
//             child: Column(
//           children: [
//             StackWidget(
//               hintText: "Search Subscriptions",
//               text: "Subscription",
//               onTap: () {
//                 Navigator.of(context).pushNamed("addsubscriber");
//               },
//               arrow: Icons.arrow_back,
//             ),
//             Container(
//               width: screenWidth,
//               padding: EdgeInsets.all(30),
//               color: Color(0xFFf5f5f5),
//               child: Column(
//                 children: [
//                   Consumer(builder: (context, ref, child) {
//                     return usersData.data == null
//                         ? Container(
//                             height: screenHeight,
//                             width: screenWidth,
//                             color: Color(0xfff5f5f5),
//                             child: Center(
//                                 child: InkWell(
//                                     onTap: () {
//                                       Navigator.of(context)
//                                           .pushNamed("editsubsriber");
//                                     },
//                                     child: Text(
//                                       "No data available",
//                                       style: TextStyle(
//                                           color: Color(0xffb4b4b4),
//                                           fontSize: 17),
//                                     ))),
//                           )
//                         : Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.white,
//                             ),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   ListView.builder(
//                                     shrinkWrap:
//                                         true, // Important to work inside a Column

//                                     itemCount: usersData.data!.length,
//                                     itemBuilder: (context, index) {
//                                       final user = usersData.data![index];
//                                       return SingleChildScrollView(
//                                         child: Column(
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 InkWell(
//                                                     onTap: () {
//                                                       ref
//                                                           .watch(
//                                                               selectionModelProvider
//                                                                   .notifier)
//                                                           .subDetails(true);
//                                                     },
//                                                     child: SubStack(
//                                                       text: usersData
//                                                           .data![index].name,
//                                                       width:
//                                                           screenWidth * 0.795,
//                                                       editBtn: "Edit",
//                                                       onTap: () {
//                                                         int? userId = usersData
//                                                             .data![index].id;
//                                                         selection
//                                                             .subscriberIndex(
//                                                                 userId);
//                                                         Navigator.of(context)
//                                                             .pushNamed(
//                                                                 "editsubscriber");
//                                                       },
//                                                     )),
//                                                 Divider(
//                                                   thickness: 1,
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                   }),
//                 ],
//               ),
//             )
//           ],
//         ));
//       }),
//       //
//     );
//   }
// }

// Widget _buildToggleButton(String text, bool isSelected) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 8),
//     child: Text(
//       text,
//       style: TextStyle(
//         fontSize: 16,
//         color: isSelected ? Colors.purple : Colors.black,
//         decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
//       ),
//     ),
//   );
// }

// import 'dart:io';
// import 'package:banquetbookingz/providers/bottomnavigationbarprovider.dart';
// import 'package:banquetbookingz/providers/getsubscribers.dart';
// import 'package:banquetbookingz/providers/selectionmodal.dart';
// import 'package:banquetbookingz/providers/subcsribersprovider.dart';
// import 'package:banquetbookingz/views.dart/addsubscriber.dart';
// import 'package:banquetbookingz/widgets/stackwidget.dart';
// import 'package:banquetbookingz/widgets/substack.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class Subscription extends ConsumerStatefulWidget {
//   const Subscription({super.key});

//   @override
//   ConsumerState<Subscription> createState() => _SubscriptionState();
// }

// class _SubscriptionState extends ConsumerState<Subscription> {
//   @override
//   void initState() {
//     super.initState();
//     // Call getUsers() when the widget is inserted into the widget tree
//     ref.read(subscribersProvider.notifier).getSubscribers();
//     // ref.read(getUserProvider.notifier).getProfilePic();
//     // Future.microtask(() {
//     //   // Get the ID passed via arguments

//     //   final id = ModalRoute.of(context)?.settings.arguments as int?;
//     //   print(id);
//     //   final ids=ref.read(selectionModelProvider).index;
//     //   print(ids);
//     //   // Get user details from your state notifier
//     //   final user = ref.read(getUserProvider.notifier).getUserById(ids!);

//     //   if (user != null) {
//     //     // Update the controllers with the user's data
//     //     ref.read(selectionModelProvider.notifier).updateEnteredemail(user.emailId ?? '');
//     //     ref.read(selectionModelProvider.notifier).updateEnteredName(user.firstName ?? '');
//     //   //    if (user.profilepic != null) {
//     //   //   ref.read(imageProvider.notifier).setProfilePic(XFile(user.profilepic!));
//     //   // }
//     //     // ... do the same for other fields
//     //   }
//     // });
//   }

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     List<bool> isSelected = [true, false, false, false];
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final usersData = ref.watch(subscribersProvider);

//     return Scaffold(
//       body: Consumer(builder: (context, ref, child) {
//         final _selectedIndex = ref.watch(pageIndexProvider);
//         final selection = ref.watch(selectionModelProvider.notifier);
//         final user = ref.watch(selectionModelProvider);
//         return SingleChildScrollView(
//             child: Column(
//           children: [
//             StackWidget(
//               hintText: "Search Subscriptions  ",
//               text: "Subscription",
//               onTap: () {
//                 Navigator.of(context).pushNamed("addsubscriber");
//               },
//               arrow: Icons.arrow_back,
//             ),
//             Container(
//               width: screenWidth,
//               padding: EdgeInsets.all(30),
//               color: Color(0xFFf5f5f5),
//               child: Column(
//                 children: [
//                   Consumer(builder: (context, ref, child) {
//                     return usersData.data == null
//                         ? Container(
//                             height: screenHeight,
//                             width: screenWidth,
//                             color: Color(0xfff5f5f5),
//                             child: Center(
//                                 child: InkWell(
//                                     onTap: () {
//                                       Navigator.of(context)
//                                           .pushNamed("editsubsriber");
//                                     },
//                                     child: Text(
//                                       "No data available",
//                                       style: TextStyle(
//                                           color: Color(0xffb4b4b4),
//                                           fontSize: 17),
//                                     ))),
//                           )
//                         : Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.white,
//                             ),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   ListView.builder(
//                                     shrinkWrap:
//                                         true, // Important to work inside a Column

//                                     itemCount: usersData.data!.length,
//                                     itemBuilder: (context, index) {
//                                       final user = usersData.data![index];
//                                       return SingleChildScrollView(
//                                         child: Column(
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 InkWell(
//                                                     onTap: () {
//                                                       ref
//                                                           .watch(
//                                                               selectionModelProvider
//                                                                   .notifier)
//                                                           .subDetails(true);
//                                                     },
//                                                     child: SubStack(
//                                                       text: usersData
//                                                           .data![index].name,
//                                                       width:
//                                                           screenWidth * 0.795,
//                                                       editBtn: "Edit",
//                                                       onTap: () {
//                                                         int? userId = usersData
//                                                             .data![index].id;
//                                                         selection
//                                                             .subscriberIndex(
//                                                                 userId);
//                                                         Navigator.of(context)
//                                                             .pushNamed(
//                                                                 "editsubscriber");
//                                                       },
//                                                     )),
//                                                 Divider(
//                                                   thickness: 1,
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                   }),
//                 ],
//               ),
//             )
//           ],
//         ));
//       }),
//       //
//     );
//   }
// }

// Widget _buildToggleButton(String text, bool isSelected) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 8),
//     child: Text(
//       text,
//       style: TextStyle(
//         fontSize: 16,
//         color: isSelected ? Colors.purple : Colors.black,
//         decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
//       ),
//     ),
//   );
// }
// import 'package:banquetbookingz/providers/selectionmodal.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:banquetbookingz/providers/subcsribersprovider.dart';
// import 'package:banquetbookingz/widgets/stackwidget.dart';
// import 'package:banquetbookingz/widgets/substack.dart';

// class Subscription extends ConsumerStatefulWidget {
//   const Subscription({super.key});

//   @override
//   ConsumerState<Subscription> createState() => _SubscriptionState();
// }

// class _SubscriptionState extends ConsumerState<Subscription> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch subscribers when the widget is inserted into the widget tree
//     ref.read(subscribersProvider.notifier).getSubscribers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final usersData = ref.watch(subscribersProvider);

//     // Ensure data is not null before accessing it
//     final subscribers = usersData.data ?? [];

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             StackWidget(
//               hintText: "Search Subscriptions",
//               text: "Subscription",
//               onTap: () {
//                 Navigator.of(context).pushNamed("addsubscriber");
//               },
//               arrow: Icons.arrow_back,
//             ),
//             Container(
//               width: screenWidth,
//               padding: const EdgeInsets.all(30),
//               color: const Color(0xFFf5f5f5),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics:
//                     const NeverScrollableScrollPhysics(), // Prevent scrolling inside GridView
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 3 / 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: subscribers.length,
//                 itemBuilder: (context, index) {
//                   final user = subscribers[index];
//                   return InkWell(
//                     onTap: () {
//                       final userId = user.id;
//                       ref
//                           .read(selectionModelProvider.notifier)
//                           .subscriberIndex(userId);
//                       Navigator.of(context).pushNamed("editsubscriber");
//                     },
//                     child: SubStack(
//                       text: user.name ?? "No Name",
//                       width: screenWidth * 0.795,
//                       editBtn: "Edit",
//                       onTap: () {
//                         // Handle edit button click if needed
//                       },
//                       additionalInfo: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Annual Price: ${user.annualPricing ?? 'N/A'}",
//                           ),
//                           Text(
//                             "Quarterly Price: ${user.quaterlyPricing ?? 'N/A'}",
//                           ),
//                           Text(
//                             "Monthly Price: ${user.monthlyPricing ?? 'N/A'}",
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banquetbookingz/widgets/stackwidget.dart';
import 'package:banquetbookingz/providers/new_subscription_get.dart';
import 'package:banquetbookingz/models/new_subscriptionplan.dart';
import 'package:banquetbookingz/views.dart/gold_subscription.dart';
import 'package:banquetbookingz/views.dart/diamond_subscription.dart';

class Subscription extends ConsumerWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionPlansAsyncValue = ref.watch(subscriptionPlansProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StackWidget(
              hintText: "Search Subscriptions",
              text: "Subscription",
              onTap: () {
                Navigator.of(context).pushNamed("addsubscriber");
              },
              arrow: Icons.arrow_back,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: subscriptionPlansAsyncValue.when(
                  data: (subscriptionPlans) {
                    if (subscriptionPlans.isEmpty) {
                      return const Center(
                        child: Text(
                          "No subscriptions available",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    // Categorize the plans
                    final goldPlans = subscriptionPlans
                        .where(
                            (plan) => plan.plan.toLowerCase().contains('gold'))
                        .toList();
                    final platinumPlans = subscriptionPlans
                        .where((plan) =>
                            plan.plan.toLowerCase().contains('platinum'))
                        .toList();
                    final diamondPlans = subscriptionPlans
                        .where((plan) =>
                            plan.plan.toLowerCase().contains('diamond'))
                        .toList();
                    final otherPlans = subscriptionPlans
                        .where((plan) =>
                            !plan.plan.toLowerCase().contains('gold') &&
                            !plan.plan.toLowerCase().contains('platinum') &&
                            !plan.plan.toLowerCase().contains('diamond'))
                        .toList();

                    // Create the cards
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (goldPlans.isNotEmpty)
                          _buildPlanCard(
                              context,
                              "Gold",
                              goldPlans,
                              Colors.amber[600]!,
                              GoldSubscriptionScreen(
                                goldPlans: goldPlans,
                              )),
                        if (platinumPlans.isNotEmpty)
                          _buildPlanCard(
                              context,
                              "Platinum",
                              platinumPlans,
                              Colors.blueGrey[700]!,
                              PlatinumSubscriptionScreen()),
                        if (diamondPlans.isNotEmpty)
                          _buildPlanCard(
                              context,
                              "Diamond",
                              diamondPlans,
                              Colors.blue[900]!,
                              DiamondSubscriptionScreen(
                                  diamondPlans: diamondPlans)),
                        if (otherPlans.isNotEmpty)
                          _buildPlanCard(context, "Others", otherPlans,
                              Colors.grey[500]!, OtherSubscriptionScreen()),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, String title,
      List<SubscriptionPlan> plans, Color cardColor, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destinationScreen,
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: cardColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${plans.length} Plans',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlatinumSubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Platinum Subscriptions')),
      body: Center(child: Text('Platinum Subscription Details')),
    );
  }
}

class OtherSubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Other Subscriptions')),
      body: Center(child: Text('Other Subscription Details')),
    );
  }
}
