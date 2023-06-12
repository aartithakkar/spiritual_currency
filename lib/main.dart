import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../components/icon_content.dart';
import '../components/reusable_card.dart';
import '../components/image_content.dart';
import '../components/image_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'scale_size.dart';
import 'package:wakelock/wakelock.dart';

enum audioState {
  unmute,
  mute,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual Currency',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(title: 'Cureman'),
    );
  }
}

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
  audioState selectedAudioState = audioState.unmute;
  int height = 180;
  late int _guruImageSelected;
  late String _guruImagePath;
  late int _lordImageSelected;
  late String _lordImagePath;
  int userRecitations = 108;
  int _recitations = 0;
  bool isCounterRunning = false;
  Duration mantraDuration = const Duration(seconds: 0);
  Duration mantraPosition = const Duration(seconds: 0);
  Duration totalMantraDuration = const Duration(seconds: 0);
  bool isMantraPlay = false;
  final player = AudioPlayer();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _goalText = 'What\'s my goal?';
  String guruText = 'Find my     Guru/Mentor';
  String userMantra = 'My Mantra';
  final myController = TextEditingController();
  final recitationController = TextEditingController();
  final mantraController = TextEditingController();

  // list of images
  List guruImgList = [
    'assets/graphics/SP.jpeg',
    'assets/graphics/SV.jpeg',
    'assets/graphics/SP.jpeg',
    'assets/graphics/SV.jpeg',
  ];
  List guruCaptionList = [
    'A.C. Bhaktivedanta Swami Prabhupada',
    'Srimad Vallabhacharya',
    'A.C. Bhaktivedanta Swami Prabhupada',
    'Srimad Vallabhacharya',
  ];
  List lordImgList = [
    'assets/graphics/SP.jpeg',
    'assets/graphics/SV.jpeg',
    'assets/graphics/Gaur_Nitai.jpeg',
    'assets/graphics/SV.jpeg',
  ];
  List lordCaptionList = [
    'A.C. Bhaktivedanta Swami Prabhupada',
    'Srimad Mahaprabhu',
    'Gauranga Nityananda',
    'Srimad Vallabhacharya',
  ];

  List mantraList = [
    'Hare Krishna Hare Krishna Krishna Krishna Hare Hare Hare Rama Hare Rama Rama Rama Hare Hare',
    'Shri Krishna Sharanam Mama',
    'Om',
    '',
  ];

  File? guruImage;
  File? lordImage;
  final ImagePicker picker = ImagePicker();
  String guruImageAsset = '';
  String lordImageAsset = '';

  void setGuruImageSelected(int selection, String imgPath) async {
    final SharedPreferences prefs = await _prefs;
    _guruImageSelected = selection;
    _guruImagePath = imgPath;
    _guruImageSelected =
        await prefs.setInt('guruImageSelected', selection).then((bool success) {
      return selection;
    });
    _guruImagePath =
        await prefs.setString('guruImagePath', imgPath).then((bool success) {
      return imgPath;
    });
  }

  void getGuruImageSelected() async {
    _guruImageSelected = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('guruImageSelected') ?? -1;
    });
    _guruImagePath = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString('guruImagePath') ?? '';
    });

    if (_guruImageSelected != -1) {
      guruImageAsset = guruImgList[_guruImageSelected];
    } else if (_guruImagePath != '') {
      guruImage = File(_guruImagePath);
    }
  }

  void setLordImageSelected(
      int selection, String imgPath, String goalText) async {
    final SharedPreferences prefs = await _prefs;
    _lordImageSelected = selection;
    _lordImagePath = imgPath;
    _goalText = goalText;
    _lordImageSelected =
        await prefs.setInt('lordImageSelected', selection).then((bool success) {
      return selection;
    });
    _lordImagePath =
        await prefs.setString('lordImagePath', imgPath).then((bool success) {
      return imgPath;
    });
    _goalText =
        await prefs.setString('goalText', goalText).then((bool success) {
      return goalText;
    });
  }

  void getLordImageSelected() async {
    _lordImageSelected = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('lordImageSelected') ?? -1;
    });
    _lordImagePath = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString('lordImagePath') ?? '';
    });
    _goalText = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString('goalText') ?? 'What\'s my goal?';
    });

    if (_lordImageSelected != -1) {
      lordImageAsset = lordImgList[_lordImageSelected];
    } else if (_lordImagePath != '') {
      lordImage = File(_lordImagePath);
    }
  }

  void setUserRecitations(int recitations) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      userRecitations =
          recitations > 0 ? (recitations > 99999 ? 99999 : recitations) : 108;
      _recitations = userRecitations;
      updateMantraDuration();
    });
    userRecitations = await prefs
        .setInt('userRecitations', userRecitations)
        .then((bool success) {
      return userRecitations;
    });
  }

  void setUserMantra(String mantra) async {
    if (mantra == '') {
      return;
    }
    final SharedPreferences prefs = await _prefs;
    setState(() {
      userMantra = mantra;
    });
    userMantra =
        await prefs.setString('userMantra', userMantra).then((bool success) {
      return userMantra;
    });
  }

  void getUserRecitations() async {
    userRecitations = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('userRecitations') ?? 108;
    });

    _recitations = userRecitations > 0 ? userRecitations : 108;
  }

  Future getImage(ImageSource media, bool isGuru) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      if (img != null) {
        if (isGuru == true) {
          guruImage = File(img.path);
          setGuruImageSelected(-1, img.path);
        } else {
          lordImage = File(img.path);
          setLordImageSelected(-1, img.path, '');
        }
      }
    });
  }

  void myAlert(bool isGuru) {
    myController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final PageController controller = PageController();
          int pageChanged = 0;
          int listLength =
              (isGuru == true) ? guruImgList.length : lordImgList.length;
          List imgList = (isGuru == true) ? guruImgList : lordImgList;
          List captionList =
              (isGuru == true) ? guruCaptionList : lordCaptionList;
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.maxFinite,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery, isGuru);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: PageView(
                        controller: controller,
                        children: [
                          for (var i = 0; i < listLength; i++)
                            Center(
                              child: Column(
                                children: [
                                  Expanded(child: Image.asset(imgList[i])),
                                  Expanded(child: Text(captionList[i])),
                                ],
                              ),
                              //child: SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, child: item),
                            ),
                        ],
                        onPageChanged: (index) {
                          setState(() {
                            pageChanged = index;
                          });
                          //print(guruImageSelected);
                        },
                      ),
                      onTap: () {
                        //add set state if doesn't get detected on each press
                        // print('selected page $pageChanged');
                        setState(() {
                          Navigator.pop(context);
                          if (isGuru == true) {
                            setGuruImageSelected(pageChanged, '');
                            guruImageAsset = guruImgList[pageChanged];
                            //guruImage = null;
                          } else {
                            setLordImageSelected(pageChanged, '', '');
                            lordImageAsset = lordImgList[pageChanged];
                            //lordImage = null;
                          }
                        });
                      },
                    ),
                  ),
                  if (isGuru == false)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: myController,
                            decoration: new InputDecoration.collapsed(
                              hintText: 'Type my goal',
                            ),
                            onEditingComplete: () {
                              Navigator.pop(context);
                              //goalText = myController.text;
                              setLordImageSelected(-1, '', myController.text);
                              //lordImage = null;
                              //lordImageSelected = -1;
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }

  void selectRecitation() {
    recitationController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose recitation to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.maxFinite,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      setUserRecitations(1);
                      Navigator.pop(context);
                    },
                    child: Text('1'),
                  ),
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      setUserRecitations(5);
                      Navigator.pop(context);
                    },
                    child: Text('5'),
                  ),
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      setUserRecitations(9);
                      Navigator.pop(context);
                    },
                    child: Text('9'),
                  ),
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      setUserRecitations(11);
                      Navigator.pop(context);
                    },
                    child: Text('11'),
                  ),
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      setUserRecitations(108);
                      Navigator.pop(context);
                    },
                    child: Text('108'),
                  ),
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      setUserRecitations(99999);
                      Navigator.pop(context);
                    },
                    child: Text('Infinite'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: recitationController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Type my recitation',
                          ),
                          onEditingComplete: () {
                            Navigator.pop(context);
                            setUserRecitations(
                                int.parse(recitationController.text));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void mantraDialog() {
    mantraController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Select my mantra'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.maxFinite,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              mantraList[index],
                              style: const TextStyle(color: Colors.black),
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              setUserMantra(mantraList[index]);
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              color: Colors.grey[600],
                            ),
                        itemCount: mantraList.length),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.11,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: mantraController,
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Type my mantra',
                                ),
                                onEditingComplete: () {
                                  Navigator.pop(context);
                                  setUserMantra(mantraController.text);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const FloatingActionButton.small(
                        onPressed: null,
                        tooltip: 'Upload mantra sound',
                        child: Icon(
                          Icons.music_note_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

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
      await player.pause();
    } else {
      await player.play(AssetSource('sounds/SP3.mp3'));
    }
  }

  void loadMantra() async {
    await player.setSource(AssetSource('sounds/SP3.mp3'));
    mantraDuration = (await player.getDuration())!;
    totalMantraDuration =
        Duration(milliseconds: mantraDuration.inMilliseconds * _recitations);

    userMantra = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString('userMantra') ?? 'My Mantra';
    });

    setState(() {
      mantraPosition = totalMantraDuration;
    });

    print('########## song Duration is $mantraDuration.');
  }

  void getMantraDuration() async {
    mantraDuration = (await player.getDuration())!;
    totalMantraDuration =
        Duration(milliseconds: mantraDuration.inMilliseconds * _recitations);
    mantraPosition = totalMantraDuration;
    print('########## song Duration is $mantraDuration.');
  }

  void updateMantraDuration() {
    totalMantraDuration =
        Duration(milliseconds: mantraDuration.inMilliseconds * _recitations);
    mantraPosition = totalMantraDuration;
    print('########## song Duration is $mantraDuration.');
  }

  void loadCounterState() async {
    _counts = await _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counts') ?? 0;
    });
    if (_counts > 0) {
      isCounterRunning = true;
    }
  }

  @override
  void initState() {
    super.initState();

    loadCounterState();

    _guruImageSelected = -1;
    _guruImagePath = '';
    getGuruImageSelected();
    _lordImageSelected = -1;
    _lordImagePath = '';
    getLordImageSelected();

    getUserRecitations();

    loadMantra();
    //getMantraDuration();

    player.onDurationChanged.listen((Duration d) {
      //updateMantraDuration();
      //     print('Max duration: $d');
      //setState(() {
      //mantraDuration = Duration(seconds: d.inSeconds * _recitations);
      //mantraPosition = mantraDuration;
      //print('************* $mantraDuration');
      //});
    });

    player.onPositionChanged.listen((Duration p) {
      //   print('Current position: $p');
      setState(() {
        mantraPosition = totalMantraDuration - p;
      });
    });

    player.onPlayerComplete.listen((event) {
      setState(() async {
        mantraPosition = mantraDuration;
        if (_recitations == 1) {
          _recitations = userRecitations;
          updateMantraDuration();
          player.stop();
          isMantraPlay = false;
        } else {
          _recitations--;
          updateMantraDuration();
          if (isMantraPlay == false) {
            await player.pause();
          } else {
            await player.play(AssetSource('sounds/SP3.mp3'));
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.toggle(enable: isMantraPlay | isCounterRunning);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(
                        () {
                          myAlert(false);
                        },
                      );
                    },
                    cardChild: _lordImagePath == ''
                        ? (_lordImageSelected == -1
                            ? ImageContent(
                                displayImage:
                                    AssetImage('assets/graphics/Blank.jpeg'),
                                label: _goalText)
                            : ImageContent(
                                displayImage: AssetImage(lordImageAsset),
                                label: ''))
                        : ImageContent(
                            displayImage: FileImage(lordImage!), label: ''),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      myAlert(true);
                    },
                    cardChild: _guruImagePath == ''
                        ? (_guruImageSelected == -1
                            ? ImageContent(
                                displayImage:
                                    AssetImage('assets/graphics/Blank.jpeg'),
                                label: guruText)
                            : ImageContent(
                                displayImage: AssetImage(guruImageAsset),
                                label: ''))
                        : ImageContent(
                            displayImage: FileImage(guruImage!), label: ''),
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
                        child: AutoSizeText(
                          userMantra,
                          style: kLabelTextStyle,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          presetFontSizes: [
                            40,
                            (MediaQuery.of(context).size.height *
                                MediaQuery.of(context).size.width *
                                0.00009),
                            14
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
                                        primary: Colors.black,
                                        padding: const EdgeInsets.all(8.0),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          Icon(Icons.speed),
                                          Text(
                                            ' ${_printDuration(mantraPosition)}',
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
                              child: FloatingActionButton.small(
                                onPressed: playPauseMantra,
                                child: isMantraPlay == true
                                    ? const Icon(Icons.pause)
                                    : const Icon(Icons.play_arrow),
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
                                        primary: Colors.black,
                                        padding: const EdgeInsets.all(8.0),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      onPressed: selectRecitation,
                                      child: Text(' Recitation: $_recitations'),
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
              onPress: mantraDialog,
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
                          icon: Icon(Icons.replay),
                        ),
                        TextButton(
                          onPressed: selectRecitation,
                          child: Text(
                            userRecitations.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _decrementCounter,
                          icon: Icon(Icons.exposure_minus_1),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/icons/cureman_logo.png',
                            color: Colors.black,
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
                          '${(_counts / userRecitations).floor()}',
                          style: const TextStyle(
                            color: Colors.black,
                            //padding: const EdgeInsets.all(2.0),
                            fontSize: 50.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${_counts % userRecitations}',
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

/*
  @override
  String? get restorationId => "home_screen";
*/
}

/*
Center(
// Center is a layout widget. It takes a single child and positions it
// in the middle of the parent.
child: Column(
// Column is also a layout widget. It takes a list of children and
// arranges them vertically. By default, it sizes itself to fit its
// children horizontally, and tries to be as tall as its parent.
//
// Invoke "debug painting" (press "p" in the console, choose the
// "Toggle Debug Paint" action from the Flutter Inspector in Android
// Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
// to see the wireframe for each widget.
//
// Column has various properties to control how it sizes itself and
// how it positions its children. Here we use mainAxisAlignment to
// center the children vertically; the main axis here is the vertical
// axis because Columns are vertical (the cross axis would be
// horizontal).
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
const Text(
'You have pushed the button this many times:',
),
Text(
'$_counter',
style: Theme.of(context).textTheme.headline4,
),
],
),
),*/
