import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Movie {
  final String? url;
  final String? title;
  final String? link;

  const Movie({this.url, this.title,this.link});
}

const movies = [
  Movie(
      url: 'https://play-lh.googleusercontent.com/fWs8MchFvA6pjWOy9-JPPFUaKZ8ZPf-NnctYDJzCZD1widC4ccjoJaseKdi5tsU4TBW_Ziu4u1a3Ydxqycjd=w200-h300-rw'
      , title: 'Moana',link: 'https://play.google.com/store/movies/details/Moana?id=dh27eCW4FOQ.P'),
  Movie(
      url:
          'https://play-lh.googleusercontent.com/QOwYeu-cYlmPV7nT8yETQjM4YUdVGcbGQ2xI-gxk--FlZmFTNEy8KASSdbhMM7QSTL-J=w200-h300-rw',
      title: 'WALL-E',link: 'https://play.google.com/store/movies/details/WALL_E?id=5RcNwlq7JSw'),
  Movie(
      url:
          'https://play-lh.googleusercontent.com/E27TLOS1g3N4BF6oSke_DfT2Kd6VNAtTQfYCt4gKumthqUOPzYDfRz3O-3rUZVR1vGIN7d19FoyhYJe3J2E=w200-h300-rw',
      title: 'PAW Patrol',link: 'https://play.google.com/store/movies/details/PAW_Patrol_The_Movie?id=aEQFJn3_0Ww.P'),
  Movie(
    url:
        'https://play-lh.googleusercontent.com/wjU6K0M4_V3a36DDGsqsf8x6n_u6FOQqE_6ve6GERmmbN5BQ0dN0-hPm14ScZutqX9rmy2WLucGQBepkSu4=w200-h300-rw',
    title: 'Clifford The Big Red Dog',link: 'https://play.google.com/store/movies/details/Clifford_the_Big_Red_Dog_PAW_Patrol_The_Movie_2_Mo?id=jRlsTTLZH-4.P'
  ),
  Movie(
    url:
    'https://play-lh.googleusercontent.com/3okXk_l5sg9RYC2SOBzPt-Q5hWFDbd3RAyezQ-xha_ZpvibUlopqgwyjzTHWy9b4MXD926VUuRlTfgOlPGBv=w200-h300-rw',
    title: 'Toy Story',link: 'https://play.google.com/store/movies/details/Toy_Story?id=gpmPqgOlb7o.P'
  )
];

class MoviesConceptPage extends StatefulWidget {
  @override
  _MoviesConceptPageState createState() => _MoviesConceptPageState();
}

class _MoviesConceptPageState extends State<MoviesConceptPage> {
  final pageController = PageController(viewportFraction: 0.7);
  final ValueNotifier<double?> _pageNotifier = ValueNotifier(0.0);

  void _listener() {
    _pageNotifier.value = pageController.page;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      pageController.addListener(_listener);
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.removeListener(_listener);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(30);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ValueListenableBuilder<double?>(
                valueListenable: _pageNotifier,
                builder: (context, value, child) {
                  return Stack(
                    children: movies.reversed
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (entry) => Positioned.fill(
                            child: ClipRect(
                              clipper: MyClipper(
                                percentage: value,
                                title: entry.value.title,
                                index: entry.key,
                              ),
                              child: Image.network(
                                entry.value.url!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: size.height / 3,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.white,
                  Colors.white60,
                  Colors.white24,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
            ),
          ),
          PageView.builder(
              itemCount: movies.length,
              controller: pageController,
              itemBuilder: (context, index) {
                final lerp =
                    lerpDouble(0, 1, (index - _pageNotifier.value!).abs())!;

                double opacity =
                    lerpDouble(0.0, 0.5, (index - _pageNotifier.value!).abs())!;
                if (opacity > 1.0) opacity = 1.0;
                if (opacity < 0.0) opacity = 0.0;
                return Transform.translate(
                  offset: Offset(0.0, lerp * 50),
                  child: Opacity(
                    opacity: (1 - opacity),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        color: Colors.white,
                        borderOnForeground: true,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: borderRadius,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          height: size.height / 1.5,
                          width: size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 23.0, left: 23.0, right: 23.0),
                                  child: ClipRRect(
                                    borderRadius: borderRadius,
                                    child: Image.network(
                                      movies[index].url!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    movies[index].title!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            left: size.width / 4,
            bottom: 20,
            width: size.width / 2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  'SHOW MOVIE',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _launchURL(movies[pageController.initialPage].link.toString())),
          ),
          const Positioned(
            top: 30,
            left: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(5, 5),
                      blurRadius: 20,
                      spreadRadius: 5),
                ],
              ),
              child: BackButton(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  final double? percentage;
  final String? title;
  final int? index;

  MyClipper({
    this.percentage = 0.0,
    this.title,
    this.index,
  });

  @override
  Rect getClip(Size size) {
    int currentIndex = movies.length - 1 - index!;
    final realPercent = (currentIndex - percentage!).abs();
    if (currentIndex == percentage!.truncate()) {
      return Rect.fromLTWH(
          0.0, 0.0, size.width * (1 - realPercent), size.height);
    }
    if (percentage!.truncate() > currentIndex) {
      return Rect.fromLTWH(0.0, 0.0, 0.0, size.height);
    }
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
