import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moviemazz/screens/details_screen.dart';
import 'package:moviemazz/screens/search_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];
  int selectedCategoryIndex = 0;
  final categories = ["All", "Hot", "New"];

  @override
  void initState() {
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
    fetchMovies();
  }

  Future fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(10),
      )),
  backgroundColor: Colors.deepPurple,
  elevation: 0,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      
      
      Row(
        children: [
          const Text(
            "Movie Mazz",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      IconButton(onPressed: (){ Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => search_screenState(),
      ),
    );},
  icon: Icon(CupertinoIcons.search,
  color: const Color.fromARGB(255, 255, 255, 255),
                  size: 28,),
  ),
    ],
  ),
),

      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
      
        children: [
          
          Expanded(
            
            child: movies.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index]['show'];
                      final imageUrl = movie['image'] != null
                          ? movie['image']['medium']
                          : null;
                      final title = movie['name'] ?? "No title";
                      final genres = movie['genres']?.join(", ") ?? "Unknown";
                      final duration = movie['runtime']?.toString() ?? "Unknown";
                      final rating = movie['rating']?['average']?.toString() ?? "N/A";

                      return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(movie: movie),
      ),
    );
  },
                      
                      
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 3,
                          child: Row(
                            children: [
                              
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        height: 120,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/defaultimg.jpg',
                                        height: 120,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 16.0),
                              
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        genres,
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "$duration min",
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            rating,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),);
                    },
                  ),
          ),
        ],
      ),
      
    );
  }
}
