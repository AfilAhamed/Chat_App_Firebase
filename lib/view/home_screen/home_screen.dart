import 'package:chat_app/controller/search_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/view/home_screen/widgets/chat_user_card.dart';
import 'package:chat_app/view/profile_screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FireStoreServices().getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchUserController>(context);
    List<UserModel> list = [];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (searchProvider.isSearching) {
            setState(() {
              searchProvider.isSearching = !searchProvider.isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white, // Navigation bar
            ),
            title: searchProvider.isSearching
                ? TextFormField(
                    onChanged: (value) {
                      searchProvider.searchList.clear();
                      for (var i in list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          searchProvider.searchList.add(i);
                          setState(() {
                            searchProvider.searchList;
                          });
                        }
                      }
                    },
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: 1.3),
                    cursorColor: Colors.white,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '  Name,Email...',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  )
                : const Text(
                    'ChatApp',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
            actions: [
              IconButton(
                  onPressed: () {
                    searchProvider.searchList.clear();

                    setState(() {
                      searchProvider.isSearching = !searchProvider.isSearching;
                    });
                  },
                  icon: Icon(searchProvider.isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search_rounded)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  userModel: FireStoreServices.me,
                                )));
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          body: StreamBuilder(
            stream: FireStoreServices().getAllUsers(),
            builder: (context, snapshoot) {
              final data = snapshoot.data?.docs;
              list =
                  data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
              if (snapshoot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (list.isEmpty) {
                return const Center(
                  child: Text('No Chats Found'),
                );
              } else {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8.0),
                    itemCount: searchProvider.isSearching
                        ? searchProvider.searchList.length
                        : list.length,
                    itemBuilder: (context, index) {
                      return ChatUserCardWidget(
                        userModel: searchProvider.isSearching
                            ? searchProvider.searchList[index]
                            : list[index],
                      );
                    });
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {},
            elevation: 0,
            tooltip: 'Messages',
            splashColor: Colors.lightBlue,
            child: const Icon(
              Icons.message_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
        ),
      ),
    );
  }
}
