import 'package:banquetbookingz/utils/banquetbookzapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banquetbookingz/providers/usersprovider.dart';
import 'package:banquetbookingz/widgets/stackwidget.dart';
import '../providers/searchtextnotifier.dart';
import "package:banquetbookingz/models/users.dart";

class Users extends ConsumerStatefulWidget {
  const Users({super.key});

  @override
  ConsumerState<Users> createState() => _UsersState();
}

class _UsersState extends ConsumerState<Users> {
  final TextEditingController _searchController = TextEditingController();

  // Store image URLs with static keys - this ensures they don't change on rebuilds
  final Map<String, String> _profileImageCache = {};

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

        if (usersData.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Filter users based on the user type and search text
        final filteredUsers = usersData.where((user) {
          final matchesFilter = (filter == null || user.userRole == filter) &&
              user.userRole != "a";
          final matchesSearch =
              searchText.isEmpty || (user.email?.contains(searchText) ?? false);
          return matchesFilter && matchesSearch;
        }).toList();

        if (filteredUsers.isEmpty) {
          return const Center(
            child: Text("No users found"),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filteredUsers.length,
          cacheExtent:
              1000, // Cache more items to reduce rebuilds when scrolling
          itemBuilder: (context, index) {
            final user = filteredUsers[index];

            // Create a stable key for this list item
            final userKey = 'user-${user.userId}';

            return Card(
              key: ValueKey(userKey),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 2.0),
              child: ListTile(
                leading: _buildUserAvatar(user),
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
                        Navigator.pushNamed(
                          context,
                          'editUser',
                          arguments: {
                            'userid': user.userId,
                            'username': user.username,
                            'email': user.email,
                            'mobileNo': user.mobileNo,
                            'userRole': user.userRole,
                            'userStatus': user.userStatus,
                            'admin': user.userRole == 'a' ? true : false,
                          },
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
                              content: const Text(
                                  "Are you sure you want to delete this user?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final notifier =
                                        ref.read(usersProvider.notifier);
                                    notifier.deleteUser(
                                        user.userId.toString(), ref);
                                    Navigator.of(context).pop();
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
        );
      },
    );
  }

  Widget _buildUserAvatar(dynamic user) {
    // If no profile pic, show default icon
    if (user.profilePic == null) {
      return const Icon(
        Icons.account_circle,
        size: 50,
        color: Colors.grey,
      );
    }

    // Get cached URL or create a new one and cache it
    String imageUrl;
    final userId = user.userId.toString();

    if (_profileImageCache.containsKey(userId)) {
      imageUrl = _profileImageCache[userId]!;
    } else {
      // Create a URL without timestamp and cache it
      imageUrl = '${Api.profilePic}/${user.userId}';
      _profileImageCache[userId] = imageUrl;
    }

    // Use standard Image.network but with stable key and error handling
    return CircleAvatar(
      radius: 30,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          key: ValueKey('avatar-$userId'),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          // Make sure we don't reload images
          cacheWidth: 120,
          cacheHeight: 120,
          // Provide fallback on error
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error,
              color: Colors.red,
              size: 40,
            );
          },
          // No loading indicator - just show the image when it's ready
          loadingBuilder: (context, child, loadingProgress) {
            // Always return the child without loading indicator
            return child;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _profileImageCache.clear();
    super.dispose();
  }
}
