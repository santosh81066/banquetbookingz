import 'package:banquetbookingz/providers/bottomnavigationbarprovider.dart';
import 'package:banquetbookingz/providers/selectionmodal.dart';
import 'package:banquetbookingz/views/category.dart';
import 'package:banquetbookingz/views/settings.dart';
import 'package:banquetbookingz/views/subscription.dart';
import 'package:banquetbookingz/views/subscriptionchart.dart';
import 'package:banquetbookingz/views/users.dart';
import 'package:banquetbookingz/widgets/recentvenders.dart';
import 'package:banquetbookingz/widgets/stackwidget.dart';
import 'package:banquetbookingz/widgets/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../providers/authprovider.dart';
import '../providers/usersprovider.dart';

class DashboardWidget extends ConsumerStatefulWidget {
  const DashboardWidget({super.key});

  @override
  ConsumerState<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends ConsumerState<DashboardWidget> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
  await ref.read(usersProvider.notifier).getUsers(ref);

  final users = ref.read(usersProvider);
  for (final user in users) {
    if (user.userId != null) {
      await ref
          .read(usersProvider.notifier)
          .getProfilePic(user.userId.toString(), ref);
    }
  }
}

// // Example API response data
//   final List<Map<String, String>> vendorData = [
//     {"name": "Vendor A", "registerDate": "15-12-2024"},
//     {"name": "Vendor B", "registerDate": "05-12-2024"},
//     {"name": "Vendor C", "registerDate": "25-12-2024"},
//     {"name": "Vendor D", "registerDate": "01-01-2025"},
//     {"name": "Vendor E", "registerDate": "06-01-2025"},
//   ];


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
     final usersData = ref.watch(usersProvider);
    final usertype = ref.watch(authProvider);
    List<Widget> pages = [
      const DashboardWidget(),
      const Users(),
      if(usertype.data!.userRole=='a') const Subscription(),
      if(usertype.data!.userRole=='a') const CategoryScreen(),
      const Settings()
    ];
    


    // Vendors Registered in the Last Month: $recentVendorCount',

    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final selectedIndex = ref.watch(pageIndexProvider);
        final dashboard = ref.watch(selectionModelProvider).dashboard;
        //  final get=ref.watch(getUserProvider.notifier);
         // Current date
      final now = DateTime.now();

      // One month back
      final oneMonthAgo = now.subtract(const Duration(days: 30));

      // Filter for vendors only
      final vendorData = usersData.where((user) {
        return user.userRole == "v";
      }).toList();

      // Parse and filter vendors created in the last month
      final recentVendorCount = vendorData.where((vendor) {
        final createdAt = vendor.createdAt;

        // Skip null `createdAt`
        if (createdAt == null || createdAt.isEmpty) return false;

        // Parse `created_at` to DateTime and filter by date range
        final registerDate = DateTime.tryParse(createdAt);
        if (registerDate == null) return false;

        return registerDate.isAfter(oneMonthAgo) &&
            registerDate.isBefore(now.add(const Duration(days: 1)));
      }).length;

      print("Latest vendors: $recentVendorCount");

        return selectedIndex == 0 && dashboard == true
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    const StackWidget(
                      hintText: 'Search with user or vendor name',
                      text: "Banquet Bookz",
                    ),
                    Container(
                      padding: const EdgeInsets.all(40),
                      color: const Color(0xFFf5f5f5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(
                                            0xffdfecf2), // Container's background color
                                        shape: BoxShape
                                            .circle, // Making the container circular
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: const Icon(
                                        Icons.person, // The person icon
                                        color: Color(0xff5dcfff), // Icon color
                                        size: 30.0, // Icon size
                                      ),
                                    ),
                                     Text(
                                      recentVendorCount.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const Text(
                                      "new vendors",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(
                                            0xffffcff2), // Container's background color
                                        shape: BoxShape
                                            .circle, // Making the container circular
                                      ),
                                      padding: const EdgeInsets.all(
                                          10),
                                      child: const Icon(
                                        Icons.person, // The person icon
                                        color: Color(0xffe328af), // Icon color
                                        size: 30.0, // Icon size
                                      ), // Padding to create space around the icon inside the container
                                    ),
                                    const Text(
                                      "42",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const Text(
                                      "subscribed",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "14 subscriptions",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      "in last month",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      "Total earned ₹10000 in",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "last 30 days",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Color(0XFF6418C3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Earnings",
                                            style: TextStyle(fontSize: 25)),
                                        Text("₹89,928",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 23))
                                      ],
                                    ),
                                    Text("Last 7 Days",
                                        style: TextStyle(fontSize: 15))
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.2,
                                  width: screenWidth * 0.7,
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine:
                                            true, // Enable the vertical grid lines
                                        getDrawingVerticalLine: (value) {
                                          return const FlLine(
                                            color: Color(
                                                0xff37434d), // Color for vertical lines
                                            strokeWidth: 1,
                                          );
                                        },
                                        // getDrawingHorizontalLine: (value) {
                                        //   return FlLine(
                                        //     color: const Color(0xff37434d), // Color for horizontal lines
                                        //     strokeWidth: 1,
                                        //   );
                                        // },
                                      ),
                                      titlesData: const FlTitlesData(show: false),
                                      borderData: FlBorderData(show: false),
                                      minX: 0,
                                      maxX: 2,
                                      minY: 0,
                                      maxY: 10,
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: [
                                            const FlSpot(0, 1),
                                            const FlSpot(1, 3),
                                            const FlSpot(2, 10),
                                            // Add other spots here
                                          ],
                                          isCurved: true,
                                          color: Colors.blue, // Line color
                                          barWidth: 4,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: false),
                                          belowBarData:
                                              BarAreaData(show: false),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Recent Vendors",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Your action here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color(
                                            0XFF6418C3), // Background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              color: Color(0XFF6418C3),
                                              width: 1),
                                          // The rounded corners
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical:
                                                12), // The padding inside the button
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            "View All",
                                            style: TextStyle(
                                                color: Color(0XFF6418C3)),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Color(0XFF6418C3),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const VendersWidget(
                                  text1: 'Swagat Grand Banquet Hall',
                                  text2: 'Bachupally, Hyderabad',
                                  text3: 'Registered on Aug 25, 2023',
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Recent Vendors",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Your action here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: const Color(
                                              0XFF6418C3), // Background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                color: Color(0XFF6418C3),
                                                width: 1),
                                            // The rounded corners
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical:
                                                  12), // The padding inside the button
                                        ),
                                        child: const Row(
                                          children: [
                                            Text(
                                              "View All",
                                              style: TextStyle(
                                                  color: Color(0XFF6418C3)),
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Color(0XFF6418C3),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const SubscriptionsWidget(
                                      text1: 'Swagat Grand Banquet Hall',
                                      text2: 'Bachupally, Hyderabad',
                                      text3: 'Start:25th Feb, 2024',
                                      text4: 'End:25th Mar, 2024')
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Subscription Ratio",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 310,
                                      width: screenWidth * 0.8,
                                      child: const MySubscriptionRatioChart()),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: const Color(0xFF6418C3),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text(
                                                  "Pro-25%",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: const Color(0XFF5DCFFF),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text("Expert-25%",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: const Color(0XFFE328AF),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text(
                                                  "Basic-25%",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: const Color(0xFFC4C4C4),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text("Pro-Plus-25%",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        )
                                      ])
                                ],
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Top Subscriptions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: const Color(0XFFEEE1FF),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Basic(54%)",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0XFF6418C3))),
                                              Text(
                                                "50",
                                                style: TextStyle(
                                                    color: Color(0XFF6418C3)),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: const Color(0XFFEEE1FF),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Pro(11%)",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0XFF6418C3))),
                                              Text(
                                                "21",
                                                style: TextStyle(
                                                    color: Color(0XFF6418C3)),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: const Color(0XFFEEE1FF),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Pro Plus(20%)",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xff6418c3))),
                                              Text(
                                                "18",
                                                style: TextStyle(
                                                    color: Color(0xff6418c3)),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: const Color(0xffeee1ff),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Bsic(20%)",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xff6418c3))),
                                              Text(
                                                "18",
                                                style: TextStyle(
                                                    color: Color(0xff6418c3)),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Column(
                            children: [
                              Text(
                                "BanquetBookz Admin Dashboard",
                                style: TextStyle(
                                    color: Color(
                                      0xFFb4b4b4,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Text(
                                "Made with in india by GoCode Creations",
                                style: TextStyle(
                                    color: Color(
                                      0xFFb4b4b4,
                                    ),
                                    fontSize: 13),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : pages.elementAt(selectedIndex);
      }),
     bottomNavigationBar: Consumer(builder: (context, ref, child) {
  final selectedIndex = ref.watch(pageIndexProvider);
  final isAdmin = usertype.data?.userRole == 'a';
  
  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Users',
    ),
    if (isAdmin)
      const BottomNavigationBarItem(
        icon: Icon(Icons.subscriptions),
        label: 'Subs',
      ),
    if (isAdmin)
        const BottomNavigationBarItem(
        icon: Icon(Icons.apartment),
        label: 'category',
      ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  return BottomNavigationBar(
    items: items,
    onTap: (index) {
      if (index >= items.length) return; // Prevents out-of-range selection
      ref.read(pageIndexProvider.notifier).setPage(index);
    },
    currentIndex: selectedIndex >= items.length ? 0 : selectedIndex,
    selectedItemColor: const Color(0xff6418c3),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  );
}),

    );
  }
}
