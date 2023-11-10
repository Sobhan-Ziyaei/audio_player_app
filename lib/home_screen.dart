import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration? duration;
  Timer? timer;
  @override
  void initState() {
    audioPlayer.setAsset('assets/music/Tame ImpalaBorderline.mp3').then(
      (value) {
        duration = value;
        audioPlayer.play();
        timer = Timer.periodic(
          const Duration(milliseconds: 200),
          (timer) {
            setState(() {});
          },
        );
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ExactAssetImage('assets/images/cover.jpg'),
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child: Container(),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: CircleAvatar(
                          child: Image.asset('assets/images/icon.jpg'),
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tame Impala',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '@Tame_Impala',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.03,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/cover.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.06),
                    child: const Text(
                      'BorderLine',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.06),
                    child: const Text(
                      'The slow Rush',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (duration != null)
                    Slider(
                      inactiveColor: Colors.white12,
                      activeColor: Colors.white,
                      max: duration!.inMilliseconds.toDouble(),
                      value: audioPlayer.position.inMilliseconds.toDouble(),
                      onChangeStart: (value) {
                        audioPlayer.pause();
                      },
                      onChangeEnd: (value) {
                        audioPlayer.play();
                      },
                      onChanged: (value) {
                        audioPlayer.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.06, right: size.width * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          audioPlayer.position.toMinutesSeconds(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        if (duration != null)
                          Text(
                            duration!.toMinutesSeconds(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.backward_fill,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (audioPlayer.playing) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.play();
                          }
                        },
                        iconSize: 56,
                        icon: Icon(
                          audioPlayer.playing
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.forward_fill,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String toMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
