import 'package:flutter/material.dart';


class DetailsScreen extends StatelessWidget {
  final dynamic movie;

  DetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
      final imageUrl = movie['image'] != null
        ? movie['image']['original']
        : 'https://via.placeholder.com/300x450.png?text=No+Image';
    final title = movie['name'] ?? "No title";
    final genres = movie['genres']?.join(", ") ?? "Unknown";
    final duration = movie['runtime']?.toString() ?? "Unknown";
    final summary = movie['summary'] ?? "No summary available";
    final rating = movie['rating']?['average']?.toString() ?? "N/A";

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
        "Movie Details",
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),

  ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Genres: $genres",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Duration: $duration min",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Rating: $rating",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                "Summary:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                summary.replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
