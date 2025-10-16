import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cureman/models/mentor.dart';

import '../common/constants.dart';
import '../components/image_content.dart';
import '../components/reusable_card.dart';
import '../models/home.dart';
import '../models/mantra.dart';
import '../models/repetition.dart';
import '../models/mantra_audio.dart';
import '../models/goal.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counts = 0;
  int height = 180;

  int userRecitations = 108;

  bool isCounterRunning = false;

  bool isMantraPlay = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _goalText = 'What\'s my goal?';
  String guruText = 'Find my     Guru/Mentor';
  final mantraAudioPlayer = AudioPlayer();

  Source _mantraAudioSource = AssetSource(mantraAudioAssetList[0]);
  Duration _mantraDuration = const Duration(minutes: 1);
  Duration _totalMantraDuration = const Duration(minutes: 1);
  Duration _mantraAudioPosition = const Duration(minutes: 1);

  File? mentorImage;
  File? goalImage;
  String mentorImageAsset = '';
  String goalImageAsset = '';

  ImageProvider mentorImageProvider =
      const AssetImage('assets/graphics/Blank.jpeg');
  ImageProvider goalImageProvider =
      const AssetImage('assets/graphics/Blank.jpeg');
  String mentorText = 'Find my     Guru/Mentor';

  late MantraModel mantraModel;
  late RepetitionModel repetitionModel;
  late MantraAudioModel mantraAudioModel;
  late HomeModel homeModel;
  late MentorModel mentorModel;
  late GoalModel goalModel;

  void _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counts++;
      if (_counts == 1) {
        isCounterRunning = true;
      }
    });
    _counts = await prefs.setInt('counts', _counts).then((bool success) {
      return _counts;
    });
  }

  void _decrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counts > 0) {
        _counts--;
        if (_counts == 0) {
          isCounterRunning = false;
        }
      }
    });
    _counts = await prefs.setInt('counts', _counts).then((bool success) {
      return _counts;
    });
  }

  void _resetCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counts = 0;
      isCounterRunning = false;
    });
    _counts = await prefs.setInt('counts', _counts).then((bool success) {
      return _counts;
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void playPauseMantra() async {
//    player.setReleaseMode(ReleaseMode.loop);
    setState(() {
      isMantraPlay = !isMantraPlay;
    });
    if (isMantraPlay == false) {
      await mantraAudioPlayer.pause();
    } else {
      await mantraAudioPlayer.play(_mantraAudioSource);
    }
  }

  void loadCounterState() async {
    _counts = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counts') ?? 0;
    });
    if (_counts > 0) {
      isCounterRunning = true;
    }
  }

  void loadMentor() async {
    await mentorModel.loadMentorImageIndex();
    await mentorModel.loadMentorImagePath();

    if (mentorModel.mentorImageIndex != -1) {
      mentorImageAsset =
          MentorModel.mentorImgList[mentorModel.mentorImageIndex].imagePath;
      mentorImageProvider = AssetImage(mentorImageAsset);
      mentorText = '';
    } else if (mentorModel.mentorImagePath != '') {
      mentorImage = File(mentorModel.mentorImagePath);
      mentorImageProvider = FileImage(mentorImage!);
      mentorText = '';
    }
  }

  void updateMentor() async {
    await mentorModel.saveMentorImageIndex(mentorModel.mentorImageIndex);
    await mentorModel.saveMentorImagePath(mentorModel.mentorImagePath);

    if (mentorModel.mentorImageIndex != -1) {
      mentorImageAsset =
          MentorModel.mentorImgList[mentorModel.mentorImageIndex].imagePath;
      setState(() {
        mentorImageProvider = AssetImage(mentorImageAsset);
        mentorText = '';
      });
    } else if (mentorModel.mentorImagePath != '') {
      mentorImage = File(mentorModel.mentorImagePath);
      setState(() {
        mentorImageProvider = FileImage(mentorImage!);
        mentorText = '';
      });
    }
  }

  void loadGoal() async {
    await goalModel.loadGoalImageIndex();
    await goalModel.loadGoalImagePath();
    await goalModel.loadGoalText();

    _goalText = goalModel.goalText;

    if (goalModel.goalImageIndex == -2) {
      goalImageAsset = 'assets/graphics/Blank.jpeg';
      goalImageProvider = AssetImage(goalImageAsset);
    } else if (goalModel.goalImageIndex == -1) {
      goalImage = File(goalModel.goalImagePath);
      goalImageProvider = FileImage(goalImage!);
    } else {
      goalImageAsset =
          GoalModel.goalImgList[goalModel.goalImageIndex].imagePath;
      goalImageProvider = AssetImage(goalImageAsset);
    }
  }

  void updateGoal() async {
    await goalModel.saveGoalImageIndex(goalModel.goalImageIndex);
    await goalModel.saveGoalImagePath(goalModel.goalImagePath);
    await goalModel.saveGoalText(goalModel.goalText);

    _goalText = goalModel.goalText;

    if (goalModel.goalImageIndex == -2) {
      goalImageAsset = 'assets/graphics/Blank.jpeg';
      setState(() {
        goalImageProvider = AssetImage(goalImageAsset);
      });
    } else if (goalModel.goalImageIndex == -1) {
      goalImage = File(goalModel.goalImagePath);
      setState(() {
        goalImageProvider = FileImage(goalImage!);
      });
    } else {
      goalImageAsset =
          GoalModel.goalImgList[goalModel.goalImageIndex].imagePath;
      setState(() {
        goalImageProvider = AssetImage(goalImageAsset);
      });
    }
  }

  void updateMantraPlayer() async {
    if (homeModel.mantraAudioIndex == -2) {
      //URL
    } else if (homeModel.mantraAudioIndex == -1) {
      //File
      _mantraAudioSource = DeviceFileSource(homeModel.mantraAudioPath);
    } else {
      _mantraAudioSource =
          AssetSource(mantraAudioAssetList[homeModel.mantraAudioIndex]);
    }

    await mantraAudioPlayer.setSource(_mantraAudioSource);
    Duration mantraDur = (await mantraAudioPlayer.getDuration())!;

    _mantraDuration = mantraDur;
    _totalMantraDuration = mantraDur * repetitionModel.remainingRepetitions;

    if (isMantraPlay == true) {
      isMantraPlay = false;
    }
    setState(() {
      _mantraAudioPosition = mantraDur * repetitionModel.remainingRepetitions;
    });
  }

  void setupMantraPlayer() async {
    await homeModel.loadMantraAudioIndex();
    await homeModel.loadMantraPath();

    updateMantraPlayer();

    mantraAudioPlayer.onDurationChanged.listen((Duration d) {
      //updateMantraDuration();
      //     print('Max duration: $d');
      //setState(() {
      //mantraDuration = Duration(seconds: d.inSeconds * recitations);
      //mantraPosition = mantraDuration;
      //print('************* $mantraDuration');
      //});
    });

    mantraAudioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _mantraAudioPosition = _totalMantraDuration - p;
      });
    });

    mantraAudioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        if (repetitionModel.remainingRepetitions == 1) {
          repetitionModel.remainingRepetitions =
              repetitionModel.selectedRepetitions;
          mantraAudioPlayer.stop();
          isMantraPlay = false;
        } else {
          repetitionModel.remainingRepetitions =
              repetitionModel.remainingRepetitions - 1;
        }
        _totalMantraDuration =
            _mantraDuration * repetitionModel.remainingRepetitions;
        _mantraAudioPosition = _totalMantraDuration;
      });
      if (isMantraPlay == false) {
        mantraAudioPlayer.pause();
      } else {
        mantraAudioPlayer.play(_mantraAudioSource);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    mantraModel = Provider.of<MantraModel>(context, listen: false);
    repetitionModel = Provider.of<RepetitionModel>(context, listen: false);
    homeModel = Provider.of<HomeModel>(context, listen: false);
    mentorModel = Provider.of<MentorModel>(context, listen: false);
    goalModel = Provider.of<GoalModel>(context, listen: false);

    loadCounterState();
    loadMentor();
    loadGoal();

    repetitionModel.loadSelectedRepetitions();
    repetitionModel.loadRemainingRepetitions();

    mantraModel.loadSelectedMantra();

    setupMantraPlayer();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    mantraAudioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Wakelock.toggle(enable: isMantraPlay | isCounterRunning);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    repetitionModel = Provider.of<RepetitionModel>(context);
    mantraModel = Provider.of<MantraModel>(context);
    mantraAudioModel = Provider.of<MantraAudioModel>(context);
    homeModel = Provider.of<HomeModel>(context);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        title: const Text('Cureman'),
        backgroundColor: const Color(0xFFFDB777),
        actions: [
          IconButton(
            //if user click this button, user can upload image from gallery
            onPressed: () async {
              if (isMantraPlay == true) {
                mantraAudioPlayer.pause();
              }
              bool? result = await context.push('/home/mantraAudio');
              if (result == true) {
                await homeModel
                    .saveMantraAudioIndex(homeModel.mantraAudioIndex);
                await homeModel.saveMantraPath(homeModel.mantraAudioPath);
                updateMantraPlayer();
              } else {
                if (isMantraPlay == true) {
                  mantraAudioPlayer.resume();
                }
              }
            },
            icon: const Icon(Icons.my_library_music_sharp),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    onPress: () async {
                      bool? result = await context.push('/home/goal');
                      if (result == true) {
                        updateGoal();
                      }
                    },
                    cardChild: ImageContent(
                        displayImage: goalImageProvider, label: _goalText),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () async {
                      bool? result = await context.push('/home/mentor');
                      if (result == true) {
                        updateMentor();
                      }
                    },
                    cardChild: ImageContent(
                        displayImage: mentorImageProvider, label: mentorText),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 1),
                  ),
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                        //child: Text(mantraModel.selectedMantra),
                        child: AutoSizeText(
                          mantraModel.selectedMantra,
                          style: kLabelTextStyle,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          presetFontSizes: [
                            40,
                            (MediaQuery.of(context).size.height *
                                MediaQuery.of(context).size.width *
                                0.000085),
                            18
                          ],

                          //overflow: TextOverflow.values,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        //color: Colors.black,
                                        decoration: kBoxDecoration,
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.all(8.0),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          const Icon(Icons.speed),
                                          Text(
                                            ' ${_printDuration(_mantraAudioPosition)}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                splashColor: Colors.blue,
                                onLongPress: () async {
                                  if (isMantraPlay == true) {
                                    mantraAudioPlayer.pause();
                                  }
                                  bool? result =
                                      await context.push('/home/mantraAudio');
                                  if (result == true) {
                                    await homeModel.saveMantraAudioIndex(
                                        homeModel.mantraAudioIndex);
                                    await homeModel.saveMantraPath(
                                        homeModel.mantraAudioPath);
                                    updateMantraPlayer();
                                  } else {
                                    if (isMantraPlay == true) {
                                      mantraAudioPlayer.resume();
                                    }
                                  }
                                },
                                child: FloatingActionButton.small(
                                  onPressed: playPauseMantra,
                                  backgroundColor: Colors.orange,
                                  //tooltip: 'Long press to modify mantra audio',
                                  child: isMantraPlay == true
                                      ? const Icon(Icons.pause)
                                      : const Icon(Icons.play_arrow),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        //color: Colors.black,
                                        decoration: kBoxDecoration,
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.all(8.0),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      onPressed: () async {
                                        bool? result = await context
                                            .push('/home/repetition');
                                        if (result == true) {
                                          setState(() {
                                            _totalMantraDuration =
                                                _mantraDuration *
                                                    repetitionModel
                                                        .remainingRepetitions;
                                            _mantraAudioPosition =
                                                _mantraDuration *
                                                    repetitionModel
                                                        .remainingRepetitions;
                                          });
                                        }
                                      },
                                      child: Text(
                                          ' Recitation: ${repetitionModel.remainingRepetitions}'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onPress: () => context.go('/home/mantra'),
            ),
          ),
          Expanded(
            child: ReusableCard(
              cardChild: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/icons/japa_mala_edited.png',
                            color: Colors.black,
                          ),
                          //Icon(Icons.motion_photos_auto_outlined),
                        ),
                        IconButton(
                          onPressed: _resetCounter,
                          icon: const Icon(Icons.replay),
                        ),
                        TextButton(
                          onPressed: () async {
                            bool? result =
                                await context.push('/home/repetition');
                            if (result == true) {
                              setState(() {
                                _totalMantraDuration = _mantraDuration *
                                    repetitionModel.remainingRepetitions;
                                _mantraAudioPosition = _mantraDuration *
                                    repetitionModel.remainingRepetitions;
                              });
                            }
                          },
                          child: Text(
                            repetitionModel.selectedRepetitions.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _decrementCounter,
                          icon: const Icon(Icons.exposure_minus_1),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/icons/cureman_logo_11.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${(_counts / repetitionModel.selectedRepetitions).floor()}',
                          style: const TextStyle(
                            color: Colors.black,
                            //padding: const EdgeInsets.all(2.0),
                            fontSize: 50.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${_counts % repetitionModel.selectedRepetitions}',
                          style: const TextStyle(
                            color: Colors.black,
                            //padding: const EdgeInsets.all(2.0),
                            fontSize: 50.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onPress: _incrementCounter,
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}