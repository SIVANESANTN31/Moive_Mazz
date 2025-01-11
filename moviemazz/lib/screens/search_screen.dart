import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviemazz/screens/details_screen.dart';


class search_screenState extends StatefulWidget {
  const search_screenState({Key? key}) : super(key: key);

  @override
  State<search_screenState> createState() => _search_screenStateState();
}

class _search_screenStateState extends State<search_screenState> {
  List<dynamic> showsList = [];
  String searchKeyword = "";

  TextEditingController controller = TextEditingController();

  Future<List<dynamic>> fetchShows() async {
    final String url = "https://api.tvmaze.com/search/shows?q=all";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load shows');
    }
  }

  List<dynamic> onSearch(String enteredKeyword, List<dynamic> data) {
    if (enteredKeyword.isEmpty) return data;
    return data
        .where((item) => item["show"]["name"]
            .toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(10),
      )),
  backgroundColor: Colors.deepPurple,
  elevation: 0,
  title:Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const Text(
        "Movie Search",
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),

  ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.transparent,
                  placeholder: "Search shows...",
                  controller: controller,
                  onChanged: (value) => setState(() => searchKeyword = value),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder(
            future: fetchShows(),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasData) {
                List<dynamic> filteredList = onSearch(searchKeyword, snapshot.data!);
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      var show = filteredList[index]["show"];
                      var imageUrl = show["image"] != null ? show["image"]["medium"] : null;
                      var title = show["name"] ?? "No title";
                      var genres = show["genres"]?.join(", ") ?? "Unknown";
                      var rating = show["rating"]?["average"]?.toString() ?? "N/A";

                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: ListTile(
                          onTap: () {
                            // Navigate to details screen
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailsScreen(movie: show),
                            ));
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl)
                                : AssetImage('assets/images/defaultimg.jpg') as ImageProvider,
                          ),
                          title: Text(
                            title,
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            genres,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: Text("Something went wrong!"),
                  ),
                );
              }
            },
          ),
        ],
      ),
     
    );
    
  }

  
}
