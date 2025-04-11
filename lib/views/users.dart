import 'package:banquetbookingz/utils/banquetbookzapi.dart';
import 'package:banquetbookingz/views/edituser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banquetbookingz/providers/usersprovider.dart';
import 'package:banquetbookingz/widgets/stackwidget.dart';
import '../providers/searchtextnotifier.dart';
import "package:banquetbookingz/models/users.dart";

class Users extends ConsumerStatefulWidget{
  const Users({super.key});

  @override
  ConsumerState<Users> createState() => _UsersState();
}

class _UsersState extends ConsumerState<Users> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StackWidget(
            textEditingController: _searchController,
            hintText: "Search users",
            text: "Users",
            onTap: () {
              Navigator.of(context).pushNamed("adduser");
            },
            arrow: Icons.arrow_back,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: "All"),
                      Tab(text: "Users"),
                      Tab(text: "Vendors"),
                      Tab(text: "Managers"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildUserList(context),
                        _buildUserList(context, filter: 'u'),
                        _buildUserList(context, filter: 'v'),
                        _buildUserList(context, filter: 'm'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context, {String? filter}) {
    return Consumer(
      builder: (context, ref, child) {
        final usersData = ref.watch(usersProvider);
        final searchText = ref.watch(searchTextProvider);
        print("this is the data for fetching $usersData");

        if (usersData.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Filter users based on the user type and search text
        final filteredUsers = usersData.where((user) {
          final matchesFilter = (filter == null || user.userRole == filter)&&user.userRole!="a";
          final matchesSearch =
              searchText.isEmpty || (user.email?.contains(searchText) ?? false);
          return matchesFilter && matchesSearch;
        }).toList();

        if (filteredUsers.isEmpty) {
          return const Center(
            child: Text("No users found"),
          );
        }

        return ListView(
         
          padding: EdgeInsets.zero,
          children: filteredUsers.map((user) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 2.0),
              child: ListTile(
                leading:Consumer(
                builder: (context, ref, child) {
                  final userNotifier = ref.watch(usersProvider);
                  final currentUser = userNotifier.firstWhere((u) => u.userId == user.userId, orElse: () => user);

                  return currentUser.profilePic != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            '${Api.profilePic}/${currentUser.userId}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                          ),
                          radius: 30,
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.grey,
                        );
                 },
               ),
                title: Text(
                  "User: ${user.username ?? "No Name"}",
                  style: const TextStyle(
                    color: Color(0xFF6418c3),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email: ${user.email ?? "No Email"}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "Mobile No: ${user.mobileNo ?? "No Mobile"}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                          //   final userModel = User(
                          //   userId: user.userId,
                          //   username: user.username,
                          //   email: user.email,
                          //   userRole: user.userRole, // Optional if available
                          //   userStatus: user.userStatus, // Optional if available
                          //   mobileNo: user.mobileNo,
                          //   profilePic: 'http://93.127.172.164:8080${user.profilePic}',
                          //   );
                          print("userside:${user.userId}");
                           print("userside:${user.username}");
                            print("userside:${user.email}");
                             print("userside:${user.userRole}");
                             print("usersidestatus:${user.userStatus}");
                          Navigator.pushNamed(
                                    context,
                                    'editUser',
                                    arguments:{'userid':user.userId,
                                                'username':user.username,
                                                'email':user.email,
                                                 'mobileNo':user.mobileNo,
                                                  'userRole':user.userRole,
                                                  'userStatus':user.userStatus,
                                                  'admin': user.userRole == 'a'?true:false,
                                                 }, // Pass User object as JSON
                                               );

                                          },
                      
                    ),
                   IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: const Text("Are you sure you want to delete this user?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final notifier = ref.read(usersProvider.notifier);
                                        notifier.deleteUser(user.userId.toString(), ref);
                                        Navigator.of(context).pop(); // Close the dialog after deletion
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
          }).toList(),
        );
      },
    );
  }
}
