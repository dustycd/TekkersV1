import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> _newsArticles = [];
  bool _isLoading = true;
  bool _hasError = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews([String query = 'soccer']) async {
    const String apiKey = 'cd2082da9b154b4eb2083a6cf2b29731';
    
    // Modify the query to include keywords related to soccer (European football)
    final String url = 'https://newsapi.org/v2/everything?q=$query+soccer+OR+football+OR+Premier+League+OR+La+Liga+OR+Bundesliga+OR+Serie+A+OR+Ligue+1&apiKey=$apiKey'; // Focused on European leagues and soccer

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Filtering articles that contain specific soccer-related keywords
          _newsArticles = data['articles'].where((article) {
            final title = article['title']?.toLowerCase() ?? '';
            final description = article['description']?.toLowerCase() ?? '';
            return title.contains('soccer') ||
                title.contains('football') ||
                description.contains('soccer') ||
                description.contains('football') ||
                title.contains('premier league') ||
                title.contains('la liga') ||
                title.contains('bundesliga') ||
                title.contains('serie a') ||
                title.contains('ligue 1');
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error fetching news: $error');
    }
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _fetchNews(query);
    }
  }

  // Function to format the published date to 'X time ago'
  String formatTimeAgo(DateTime publishedAt) {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays >= 1) {
      return difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('News', style: TextStyle(fontSize: 20, color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: NewsSearch(_newsArticles, _fetchNews));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text('Failed to load news. Please try again.'))
              : ListView.builder(
                  itemCount: _newsArticles.length,
                  itemBuilder: (context, index) {
                    final article = _newsArticles[index];
                    final publishedAt = DateTime.parse(article['publishedAt']);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (article['urlToImage'] != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  article['urlToImage'],
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title'] ?? 'No title',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    article['description'] ?? '',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Source: ${article['source']['name']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        formatTimeAgo(publishedAt),  // Displaying formatted time ago
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _launchURL(article['url']),
                                      icon: const Icon(Icons.link, size: 16),
                                      label: const Text('Read more'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(133, 250, 191, 250), // Updated color to lighter purple
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class NewsSearch extends SearchDelegate {
  final List<dynamic> newsArticles;
  final Function(String) fetchNews;

  NewsSearch(this.newsArticles, this.fetchNews);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    fetchNews(query);
    return Container(); // No UI here as it's handled in the original screen
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}