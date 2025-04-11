import 'package:banquetbookingz/providers/authprovider.dart';
import 'package:banquetbookingz/views/addcategory.dart';
import 'package:banquetbookingz/views/addsubscriber.dart';
import 'package:banquetbookingz/views/adduser.dart';
import 'package:banquetbookingz/views/alltransactions.dart';
import 'package:banquetbookingz/views/category.dart';
import 'package:banquetbookingz/views/editsubscriber.dart';
import 'package:banquetbookingz/views/edituser.dart';
import 'package:banquetbookingz/views/example.dart';
import 'package:banquetbookingz/views/loginpage.dart';
import 'package:banquetbookingz/views/subscription.dart';
import 'package:banquetbookingz/views/uploadphoto.dart';
import 'package:banquetbookingz/views/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:banquetbookingz/models/users.dart";
import "package:banquetbookingz/views/addsubplan.dart";

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    print('Main.dart build');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF6418C3),
        fontFamily: 'Montserrat',
        // Define the default button theme
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF6418c3), // Login button color
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6418c3)),
        useMaterial3: true,
      ),
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: Consumer(builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final authNotifier = ref.read(authProvider.notifier);
        print("this is admin main page******************************************************");

        // Fetch and log the user role
        authNotifier.getUserRole().then((role) {
          print('User role on restart: $role');
        });
        return FutureBuilder(
          future: ref.watch(authProvider.notifier).isAuthenticated(),
          builder: (context, snapshot) {
            print('snapdata---${snapshot.data}');
            print('snapconnectionstate---${snapshot.connectionState}');
            print('connectionstate---------${ConnectionState.done}');
            // Check the authentication status
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                // If the user is logged in, go to the main page
                return const DashboardWidget();
              } else {
                // If the user is not logged in, go to the login page
                return const LoginPage();
              }
            } else {
              // Show a loading spinner while checking authentication status
              return const CircularProgressIndicator();
            }
          },
        );
      }),
      routes: {
        // "mainpage":(context) => const MainPage(),
        "uploadphoto": (context) => const UploadPhoto(),
        "dashboard": (context) => const DashboardWidget(),
        "users": (context) => const Users(),
        "adduser": (context) => const AddUser(),
        'editUser': (context) => const EditUser(),
        "alltransactions": (context) => const AllTransactions(),
        "editsubscriber": (context) => const EditSubscriber(),
        "addsubscriber": (context) => const AddSubscriber(),
        "getsubscriptions": (context) => const Subscription(),
        "addsubplans":(context) => const AddSubPlans(),
        "category":(context) => const CategoryScreen(),
        "addcategory":(context) => const AddCategory()
      },
    );
  }
}
