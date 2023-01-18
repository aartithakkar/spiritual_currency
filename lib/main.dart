import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';
import '../components/icon_content.dart';
import '../components/reusable_card.dart';
import '../components/image_content.dart';
import '../components/image_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

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
  int _counter = 0;
  int _counts = 0;
  int _rounds = 0;
  audioState selectedAudioState = audioState.unmute;
  int height = 180;
  int guruImageSelected = 0;
  int lordImageSelected = 0;
  int userRecitations = 108;
  int _recitations = 0;
  Duration mantraDuration = const Duration(seconds: 0);
  Duration mantraPosition = const Duration(seconds: 0);
  Duration totalMantraDuration = const Duration(seconds: 0);
  bool isMantraPlay = false;
  final player = AudioPlayer();


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
    'KrishnaMantraList',
    'GaneshMantraList',
  ];

  List krishnaMantraList = [
    'Om Namo Bhagavate Vasudevaya',
    'Hare Krishna Hare Krishna Krishna Krishna Hare Hare Hare Rama Hare Rama Rama Rama Hare Hare',
  ];

  File? guruImage;
  File? lordImage;
  final ImagePicker picker = ImagePicker();
  String guruImageAsset = '';
  String lordImageAsset = '';

  Future getImage(ImageSource media, bool isGuru) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      if (img != null) {
        if (isGuru == true) {
          guruImage = File(img.path);
          guruImageAsset = '';
        } else {
          lordImage = File(img.path);
          lordImageAsset = '';
        }
      }
    });
  }

  void myAlert(bool isGuru) {
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
                            guruImageSelected = pageChanged;
                            guruImageAsset = guruImgList[guruImageSelected];
                            guruImage = null;
                          } else {
                            lordImageSelected = pageChanged;
                            lordImageAsset = lordImgList[lordImageSelected];
                            lordImage = null;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counts++;
      if (_counts == _recitations) {
        _rounds++;
        _counts = 0;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counts == 0) {
        if (_rounds > 0) {
          _rounds--;
          _counts = 107;
        }
      } else {
        _counts--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counts = 0;
      _rounds = 0;
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
    totalMantraDuration = Duration(milliseconds: mantraDuration.inMilliseconds * _recitations);
    mantraPosition = totalMantraDuration;
    print('########## song Duration is $mantraDuration.');

  }

  void getMantraDuration() async {
    mantraDuration = (await player.getDuration())!;
    totalMantraDuration = Duration(milliseconds: mantraDuration.inMilliseconds * _recitations);
    mantraPosition = totalMantraDuration;
    print('########## song Duration is $mantraDuration.');
  }

  void updateMantraDuration() {
    totalMantraDuration = Duration(milliseconds: mantraDuration.inMilliseconds * _recitations);
    mantraPosition = totalMantraDuration;
    print('########## song Duration is $mantraDuration.');
  }

  @override
  void initState() {
    super.initState();
    _recitations = userRecitations;


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

    player.onPositionChanged.listen((Duration  p) {
   //   print('Current position: $p');
      setState(() {
        mantraPosition = totalMantraDuration - p;
      });
    });

    player.onPlayerComplete.listen((event) {
      setState(() {
        mantraPosition = mantraDuration;
        if (_recitations == 1) {
          _recitations = userRecitations;
          updateMantraDuration();
          player.stop();
          isMantraPlay = false;
        } else {
          _recitations--;
          updateMantraDuration();
          player.play(AssetSource('sounds/SP3.mp3'));
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {

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
                    cardChild: lordImage == null
                        ? (lordImageAsset == ''
                            ? ImageContent(
                                displayImage:
                                    AssetImage('assets/graphics/Blank.jpeg'),
                                label: 'LORD')
                            : ImageContent(
                                displayImage: AssetImage(lordImageAsset),
                                label: 'LORD'))
                        : ImageContent(
                            displayImage: FileImage(lordImage!), label: 'LORD'),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      myAlert(true);
                    },
                    cardChild: guruImage == null
                        ? (guruImageAsset == ''
                            ? ImageContent(
                                displayImage:
                                    AssetImage('assets/graphics/Blank.jpeg'),
                                label: 'GURU')
                            : ImageContent(
                                displayImage: AssetImage(guruImageAsset),
                                label: 'GURU'))
                        : ImageContent(
                            displayImage: FileImage(guruImage!), label: 'GURU'),
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      krishnaMantraList[1],
                      style: kLabelTextStyle,
                      textAlign: TextAlign.center,
                      //overflow: TextOverflow.values,
                    ),
                  ),
                  Expanded(
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
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: FloatingActionButton.small(
                                  onPressed: playPauseMantra,
                                  child: isMantraPlay == true ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
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
                                        primary: Colors.black,
                                        padding: const EdgeInsets.all(8.0),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      onPressed: () {},
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
              onPress: () {},
            ),
          ),
          Expanded(
            child: ReusableCard(
              cardChild: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset('assets/icons/japa_mala_edited.png',
                          color: Colors.black,),
                        //Icon(Icons.motion_photos_auto_outlined),
                      ),
                      IconButton(
                        onPressed: _resetCounter,
                        icon: Icon(Icons.replay),
                      ),
                      IconButton(
                        onPressed: _decrementCounter,
                        icon: Icon(Icons.exposure_minus_1),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person_outline),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          padding: const EdgeInsets.all(2.0),
                          textStyle: kNumberTextStyle,
                        ),
                        onPressed: () {},
                        child: Text(
                          _rounds.toString(),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          padding: const EdgeInsets.all(8.0),
                          textStyle: kNumberTextStyle,
                        ),
                        onPressed: () {},
                        child: Text(
                          _counts.toString(),
                        ),
                      ),
                    ],
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
