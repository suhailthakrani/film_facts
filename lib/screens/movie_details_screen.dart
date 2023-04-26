import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetailsScreen extends StatefulWidget {
  final String imdbID;
  final String movieTitle;

  const MovieDetailsScreen({
    Key? key,
    required this.imdbID,
    required this.movieTitle,
  }) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  Map<String, dynamic> _movieData = {};
  bool _isLoading = true;

  Future<void> _fetchMovieDetails() async {
    final response = await http.get(Uri.parse(
        'http://www.omdbapi.com/?i=${widget.imdbID}&plot=full&apikey=ff5cfdfd')); // Replace with your own API key

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          setState(() {
            _movieData = data;
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to fetch movie details');
        }
      } else {
        throw Exception('Failed to fetch movie details');
      }
    } catch (e) {
      print('EROR::::$e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff8468DD),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  // const SizedBox(height: 30),
                  ClipRRect(
                    // borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _movieData['Poster'] != 'N/!' ? _movieData['Poster'] : '',
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 260),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color(0xff8468DD),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            _movieData['Title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Year : ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    _movieData['Year'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_purple500_outlined,
                                    color: Colors.yellow.shade600,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    (_movieData['Ratings']).isNotEmpty
                                        ? _movieData['Ratings'][0]['Value']
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Language : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _movieData['Language'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Country : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  _movieData['Country'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Awards : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  _movieData['Awards'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _movieData['Plot'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Directed by: ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                _movieData['Director'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Starring: ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Flexible(
                                child: Text(
                                  _movieData['Actors'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Genre: ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                _movieData['Genre'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                'Runtime: ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                _movieData['Runtime'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //         backgroundColor: Colors.deepPurple,
                          //         foregroundColor: Colors.black54),
                          //     onPressed: () {},
                          //     child: const Text('Watch Trailer'),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
