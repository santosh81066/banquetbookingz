// import 'package:banquetbookingz/providers/authprovider.dart';
// import 'package:banquetbookingz/providers/connectivityprovider.dart';
// import 'package:banquetbookingz/providers/loader.dart';
// import 'package:banquetbookingz/providers/selectionmodal.dart';
// import 'package:banquetbookingz/views.dart/mainpage.dart';
// import 'package:banquetbookingz/widgets/customelevatedbutton.dart';
// import 'package:banquetbookingz/widgets/customtextfield.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _enterEmail = TextEditingController();
//   final TextEditingController _enteredPassword = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Center(
//         child: Consumer(builder: (context, ref, child){
//           final isOnline = ref.watch(connectivityProvider);
//           return isOnline? Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(15),
//             height: screenHeight,
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "BanquetBookingz",
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Welcome to BanquetBookingz admin panel",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text("Please sign-in-to your account",
//                             style: TextStyle(fontSize: 14))
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Consumer(builder: (context, ref, child) {
//                             return CustomTextFormField(
//                               applyDecoration: true,
//                               width: screenWidth * 0.8,
//                               hintText: "Email/Username",
//                               keyBoardType: TextInputType.emailAddress,
//                               suffixIcon: Icons.person_outline,
//                               textController: _enterEmail,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Field is required';
//                                 }
// String pattern =
//     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@?((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))?$';

//                                 RegExp regex = RegExp(pattern);
//                                 if (!regex.hasMatch(value)) {
//                                   return 'Enter a valid email address';
//                                 }
//                                 return null;
//                               },
//                             );}
//                           ),
//                           SizedBox(height: 16),
//                           Consumer(builder: (context, ref, child){
//                             final controller=ref.watch(selectionModelProvider.notifier);
//                             return CustomTextFormField(
//                               applyDecoration: true,
//                               width: screenWidth * 0.8,
//                               hintText: "Password",
//                               keyBoardType: TextInputType.text,
//                               suffixIcon: Icons.lock_outline,
//                               textController: _enteredPassword,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Field is required';
//                                 }
//                                 // Add more conditions here if you need to check for numbers, special characters, etc.
//                                 return null; // Return null if the entered password is valid
//                               },
//                             );}
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       width: screenWidth * 0.8,
//                       child: Row(
//                         children: [
//                           // Consumer(builder: (context, ref, build) {
//                           //   var select =
//                           //       ref.read(selectionModelProvider.notifier);
//                           //   var val = ref.watch(selectionModelProvider).checkBox;
//                           //   return Expanded(
//                           //     child: ListTile(
//                           //       contentPadding: EdgeInsets.zero,
//                           //       leading: Checkbox(
//                           //         value: val,
//                           //         focusColor: Color(0XFFb0b0b0),
//                           //         side: BorderSide(color: Color(0XFFb0b0b0)),
//                           //         onChanged: (newValue) {
//                           //           select.toggleCheckBox(newValue);
//                           //         },
//                           //       ),
//                           //       title: GestureDetector(
//                           //         // onTap: () {
//                           //         //   select.toggleCheckBox(!val);
//                           //         // },
//                           //     un    child: Text(
//                           //           'Remember me',
//                           //           style: TextStyle(
//                           //               color: val
//                           //                   ? Color(0xFF330099)
//                           //                   : Color(0xFFb0b0b0),
//                           //               fontSize: 12),
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   );
//                           // }),
//                           TextButton(
//                             onPressed: () {
//                               // TODO: Implement forgot password functionality
//                             },
//                             child: Text(
//                               "Forgot Password?",
//                               style: TextStyle(color: Color(0xFF6418C3)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Consumer(builder: (context, ref, child) {
//                       final login = ref.watch(authProvider.notifier);
//                       final val = ref.watch(selectionModelProvider);
//                       final isLoading = ref.watch(loadingProvider);

//                       return CustomElevatedButton(
//                         text: "Login",
//                         borderRadius: 10,
//                         width: 300,
//                         onPressed: isLoading
//                             ? null
//                             : () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   // If the form is valid, proceed with the login process
//                                   final LoginResult result =
//                                       await login.adminLogin(_enterEmail.text,
//                                           _enteredPassword.text, ref);
//                                    if (result.statusCode == 400) {
//                                     // If an error occurred, show a dialog box with the error message.
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return AlertDialog(
//                                           title: Text('Login Error'),
//                                           content: Text(result.errorMessage ??
//                                               'An unknown error occurred.'),
//                                           actions: <Widget>[
//                                             TextButton(
//                                               child: Text('OK'),
//                                               onPressed: () {
//                                                 Navigator.of(context)
//                                                     .pop(); // Close the dialog box
//                                               },
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   }
//                                 }
//                               },
//                         isLoading: isLoading,
//                         backGroundColor: Color(0xFF6418C3),
//                         foreGroundColor: Colors.white,
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ):Text("No Internet connection");}
//         ),
//       ),
//     );
//   }
// }
import 'package:banquetbookingz/providers/authprovider.dart';
import 'package:banquetbookingz/providers/connectivityprovider.dart';
import 'package:banquetbookingz/providers/loader.dart';
import 'package:banquetbookingz/providers/selectionmodal.dart';
import 'package:banquetbookingz/widgets/customelevatedbutton.dart';
import 'package:banquetbookingz/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _enterEmail = TextEditingController();
  final TextEditingController _enteredPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          final isOnline = ref.watch(connectivityProvider);
          return isOnline
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  height: screenHeight,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "BanquetBookingz",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome to BanquetBookingz admin panel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Please sign-in-to your account",
                                  style: TextStyle(fontSize: 14))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Consumer(builder: (context, ref, child) {
                                  return CustomTextFormField(
                                    applyDecoration: true,
                                    width: screenWidth * 0.8,
                                    hintText: "Email/Username",
                                    keyBoardType: TextInputType.emailAddress,
                                    suffixIcon: Icons.person_outline,
                                    textController: _enterEmail,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field is required';
                                      }
                                      String pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@?((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))?$';

                                      RegExp regex = RegExp(pattern);
                                      if (!regex.hasMatch(value)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  );
                                }),
                                const SizedBox(height: 16),
                                Consumer(builder: (context, ref, child) {
                                  final controller = ref
                                      .watch(selectionModelProvider.notifier);
                                  return CustomTextFormField(
                                    applyDecoration: true,
                                    width: screenWidth * 0.8,
                                    hintText: "Password",
                                    keyBoardType: TextInputType.text,
                                    suffixIcon: Icons.lock_outline,
                                    textController: _enteredPassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field is required';
                                      }
                                      // Add more conditions here if you need to check for numbers, special characters, etc.
                                      return null; // Return null if the entered password is valid
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: screenWidth * 0.8,
                            child: Row(
                              children: [
                             
                                TextButton(
                                  onPressed: () {
                                    //forgot password
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Color(0xFF6418C3)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Consumer(builder: (context, ref, child) {
                            final login = ref.watch(authProvider.notifier);
                            final val = ref.watch(selectionModelProvider);
                            final isLoading = ref.watch(loadingProvider);

                            return CustomElevatedButton(
                              text: "Login",
                              borderRadius: 10,
                              width: 300,
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        // If the form is valid, proceed with the login process
                                        final LoginResult result =
                                            await login.adminLogin(
                                          _enterEmail.text,
                                          _enteredPassword.text,
                                          ref,
                                        );
                                        if (result.statusCode == 401) {
                                          // If an error occurred, show a dialog box with the error message.
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Login Error'),
                                                content: Text(result
                                                        .errorMessage ??
                                                    '${result.errorMessage}'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog box
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                              isLoading: isLoading,
                              backGroundColor: const Color(0xFF6418C3),
                              foreGroundColor: Colors.white,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                )
              : const Text("No Internet connection");
        }),
      ),
    );
  }
}
