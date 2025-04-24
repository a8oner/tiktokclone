import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/authentication/user.dart';
import 'package:tiktok_clone/home/profile/profile_screen.dart';
import 'package:tiktok_clone/home/search/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchController1 controllerSearch = Get.put(SearchController1());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 6,
          backgroundColor: Colors.black54,
          title: TextFormField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                borderRadius: BorderRadius.circular(6.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                borderRadius: BorderRadius.circular(6.0),
              ),
              hintText: "search here....",
              hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            ),
            onFieldSubmitted: (textInput) {
              controllerSearch.searchForUser(textInput);
            },
          ),
        ),
        body: controllerSearch.usersSearchedList.isEmpty
            ? Center(
                child: Image.asset(
                "images/search.png",
                width: MediaQuery.of(context).size.width * .5,
              ))
            : ListView.builder(
                itemCount: controllerSearch.usersSearchedList.length,
                itemBuilder: (context, index) {
                  User eachSearchedUserRecord =
                      controllerSearch.usersSearchedList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Get.to(ProfileScreen(
                            visitUserID: eachSearchedUserRecord.uid.toString(),
                          ));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                eachSearchedUserRecord.image.toString()),
                          ),
                          title: Text(
                            eachSearchedUserRecord.name.toString(),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          subtitle: Text(
                            eachSearchedUserRecord.email.toString(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Get.to(ProfileScreen(
                                  visitUserID:
                                      eachSearchedUserRecord.uid.toString(),
                                ));
                              },
                              icon: const Icon(
                                Icons.navigate_next_outlined,
                                size: 24,
                                color: Colors.redAccent,
                              )),
                        ),
                      ),
                    ),
                  );
                }),
      );
    });
  }
}
