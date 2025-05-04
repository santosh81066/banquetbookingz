import 'dart:io';
import 'package:banquetbookingz/providers/imageprovider.dart';
import 'package:banquetbookingz/providers/loader.dart';
import 'package:banquetbookingz/providers/selectionmodal.dart';
import 'package:banquetbookingz/providers/usersprovider.dart';
import 'package:banquetbookingz/widgets/customelevatedbutton.dart';
import 'package:banquetbookingz/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends ConsumerStatefulWidget {
  const AddUser({super.key});

  @override
  ConsumerState<AddUser> createState() => _AddUserState();
}

class _AddUserState extends ConsumerState<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Future<ImageSource?> _showImageSourceSelector(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("widget is rebuilding");
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;

    final TextEditingController accountType =
        TextEditingController(text: "Manager");
    final TextEditingController mobileno = TextEditingController();
    final TextEditingController password = TextEditingController();

    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            width: ScreenWidth,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFf5f5f5),
            child: Column(
              children: [
                Container(
                    child: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0XFF6418C3),
                      )),
                  backgroundColor: const Color(0xfff5f5f5),
                  title: const Text(
                    "Add User",
                    style: TextStyle(color: Color(0XFF6418C3), fontSize: 20),
                  ),
                )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Photo",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Consumer(builder: (context, ref, child) {
                        final pickedImage = ref.watch(imageProvider).profilePic;
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("uploadphoto");
                              },
                              child: pickedImage != null
                                  ? SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Image.file(File(pickedImage.path)))
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFFb0b0b0),
                                            width: 2),
                                      ),
                                      width: 150,
                                      height: 150,
                                      child: Icon(Icons.person,
                                          color: Colors.grey[700], size: 120),
                                    ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              pickedImage != null ? "" : "field required",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            )
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "UserName",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "full Name",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer(builder: (context, ref, child) {
                        final controller =
                            ref.watch(selectionModelProvider.notifier);
                        return CustomTextFormField(
                          width: ScreenWidth * 0.8,
                          keyBoardType: TextInputType.text,
                          onChanged: (newVlue) {
                            controller.updateEnteredName(newVlue);
                          },
                          applyDecoration: true,
                          hintText: "Type here",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }

                            return null;
                          },
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Email ID",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer(builder: (context, ref, child) {
                        final controller =
                            ref.watch(selectionModelProvider.notifier);
                        return CustomTextFormField(
                          width: ScreenWidth * 0.8,
                          keyBoardType: TextInputType.emailAddress,
                          onChanged: (newValue) {
                            controller.updateEnteredemail(newValue);
                          },
                          applyDecoration: true,
                          hintText: "Type here",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }
                            String pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Password",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Consumer(builder: (context, ref, child) {
                        final controller =
                            ref.watch(selectionModelProvider.notifier);
                        return CustomTextFormField(
                          secureText: true,
                          width: ScreenWidth * 0.8,
                          keyBoardType: TextInputType.text,
                          onChanged: (newVlue) {
                            controller.updateEnteredPassword(newVlue);
                          },
                          applyDecoration: true,
                          hintText: "Type here",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }

                            return null;
                          },
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      // const Text(
                      //   "Gender",
                      //   style: TextStyle(color: Colors.black, fontSize: 16),
                      // ),
                      // const SizedBox(height: 10),
                      // Consumer(
                      //   builder: (context, ref, child) {
                      //     var selectGender =
                      //         ref.read(selectionModelProvider.notifier);
                      //
                      //     return Row(children: [
                      //       ref.watch(selectionModelProvider).gender == 'm'
                      //           ? CustomGenderButton(
                      //               borderRadius: 5,
                      //               text: 'Male',
                      //               onPressed: () {
                      //                 selectGender.setGender("m");
                      //               },
                      //             )
                      //           : CustomGenderButton(
                      //               borderRadius: 5,
                      //               text: 'Male',
                      //               onPressed: () {
                      //                 selectGender.setGender("m");
                      //               },
                      //               color: Colors.white,
                      //               foreGroundColor: const Color(0xFF6418C3),
                      //               borderColor: const Color(0xFF6418C3),
                      //             ),
                      //       const SizedBox(
                      //         width: 20,
                      //       ),
                      //       ref.watch(selectionModelProvider).gender == 'f'
                      //           ? CustomGenderButton(
                      //               borderRadius: 5,
                      //               text: 'Female',
                      //               onPressed: () {
                      //                 selectGender.setGender("f");
                      //               },
                      //             )
                      //           : CustomGenderButton(
                      //               borderRadius: 5,
                      //               text: 'Female',
                      //               onPressed: () {
                      //                 selectGender.setGender("f");
                      //               },
                      //               color: Colors.white,
                      //               foreGroundColor: const Color(0xFF6418C3),
                      //               borderColor: const Color(0xFF6418C3),
                      //             ),
                      //     ]);
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      const Text(
                        "Account Type",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer(builder: (context, ref, child) {
                        return CustomTextFormField(
                          width: ScreenWidth * 0.8,
                          readOnly: true,
                          textController: accountType,
                          applyDecoration: true,
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Mobile no",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Consumer(builder: (context, ref, child) {
                        final controller =
                            ref.watch(selectionModelProvider.notifier);
                        return CustomTextFormField(
                          width: ScreenWidth * 0.8,
                          keyBoardType: TextInputType.number,
                          onChanged: (newVlue) {
                            controller.updateEnteredMobile(newVlue);
                          },
                          applyDecoration: true,
                          hintText: "Type here",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Consumer(builder: (context, ref, child) {
                  final pickedImage = ref.watch(imageProvider).profilePic;
                  final selection = ref.watch(selectionModelProvider);
                  final loading = ref.watch(loadingProvider);
                  print(password.text.trim());
                  return CustomElevatedButton(
                    text: "Add User",
                    borderRadius: 10,
                    foreGroundColor: Colors.white,
                    width: double.infinity,
                    backGroundColor: const Color(0XFF6418C3),
                    isLoading: loading,
                    onPressed: loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate() &&
                                pickedImage != null) {
                              // If the form is valid, proceed with the login process

                              final UserResult result = await ref
                                  .read(usersProvider.notifier)
                                  .addUser(
                                      pickedImage,
                                      selection.name.text,
                                      selection.email.text,
                                      selection.mobile.text.trim(),
                                      selection.password.text.trim(),
                                      ref);
                              if (result.statusCode == 201) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Icon(Icons.check_circle,
                                                size: 50,
                                                color: Color(0XFF6418C3)),
                                            const SizedBox(height: 15),
                                            Text(
                                              '${selection.name.text} has been successfully added as a Manager.',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Consumer(
                                                builder: (context, ref, child) {
                                              final addUser = ref.watch(
                                                  selectionModelProvider
                                                      .notifier);
                                              return CustomElevatedButton(
                                                text: "OK",
                                                borderRadius: 20,
                                                width: 100,
                                                foreGroundColor: Colors.white,
                                                backGroundColor:
                                                    const Color(0XFF6418C3),
                                                onPressed: () {
                                                  // Navigator.of(context).pop();
                                                  addUser.toggleAddUser(false);
                                                  Navigator.of(context)
                                                      .pushNamed("dashboard");
                                                  // ref
                                                  //     .read(pageIndexProvider
                                                  //         .notifier)
                                                  //     .setPage(0);
                                                },
                                              );
                                            })
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (result.statusCode == 400) {
                                // If an error occurred, show a dialog box with the error message.
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Add Manager Error'),
                                      content: Text(result.errorMessage ??
                                          '${result.errorMessage}'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            // Navigator.of(context)
                                            //     .pushNamed("Dashboard");
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                  );
                })
              ],
            ),
          ),
        ));
      }),
    );
  }
}
