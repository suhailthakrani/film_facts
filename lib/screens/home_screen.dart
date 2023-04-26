import 'dart:developer';

import 'package:film_facts/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _apiKey = 'ff5cfdfd';
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  Future<void> _fetchMovies({required String query}) async {
    List<dynamic> results = [];
    setState(() {
      _isLoading = true;
    });
    for (int page = 1; page <= 5; page++) {
      // Change this number to fetch more pages
      final response = await http.get(Uri.parse(
          'http://www.omdbapi.com/?s=$query&page=$page&apikey=$_apiKey'));
      try {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['Response'] == 'True') {
            List<dynamic> movieList = data['Search'];
            results.addAll(movieList);
          } else {
            break;
          }
        } else {
          throw Exception('Failed to fetch movies');
        }
      } catch (e) {
        log(e.toString());
      }
    }

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = const SnackBar(
    content: Text('Press back again to exit'),
    duration: snackBarDuration,
  );

  DateTime? backButtonPressTime;
  Future<bool> handleWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff8468DD),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: WillPopScope(
        onWillPop: handleWillPop,
        child: Column(
          children: [
            const SizedBox(height: 24),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 24, 16, 16),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  hintText: "Search Your Favourite Movies Here",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _fetchMovies(
                          query: _searchController.text.trim(),
                        );
                      }
                    },
                  ),
                  // prefix: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isNotEmpty
                        ? ListView.separated(
                            itemCount: _searchResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsScreen(
                                        imdbID: _searchResults[index]['imdbID'],
                                        movieTitle: _searchResults[index]
                                            ['Title'],
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: SizedBox(
                                    height: 120,
                                    child: Row(
                                      children: [
                                        _searchResults[index]['Poster'] != 'N/A'
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Image.network(
                                                  _searchResults[index]
                                                      ['Poster'],
                                                  width: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 5),
                                              Flexible(
                                                child: Text(
                                                  _searchResults[index]
                                                      ['Title'],
                                                  style: const TextStyle(
                                                    // overflow: TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.deepPurple,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Year: ',
                                                    style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    // movie.year,
                                                    _searchResults[index]
                                                        ['Year'],
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Type: ',
                                                    style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    (_searchResults[index]
                                                            ['Type']) ??
                                                        '',
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/icon-256x256.png',
                                  height: 120,
                                  width: 120,
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Search you favourite movies here',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                SizedBox(height: 60),
                              ],
                            ),
                          ))
          ],
        ),
      ),
    );
  }
}
