import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cureman/models/home.dart';
import 'package:cureman/models/mantra_audio.dart';
import 'package:cureman/models/repetition.dart';

import '../common/constants.dart';
import '../common/scale_size.dart';

class MyMantraAudio extends StatefulWidget {
  const MyMantraAudio({super.key});

  @override
  State<MyMantraAudio> createState() => _MyMantraAudio();
}

class _MyMantraAudio extends State<MyMantraAudio>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late MantraAudioModel mantraAudioModel;
  late RepetitionModel repetitionModel;
  late HomeModel homeModel;
  int mantraAudioPreviewIndex = -1;
  final previewPlayer = AudioPlayer();

  static const List _mantraAudioList = [
    'ACBSP Hare Krishna Mantra',
    'Shri Krishna Sharanam Mama',
    'Om',
  ];

  void setFilePath(int tab, String path) {
    if (tab == 0) {
      homeModel.mantraAudioPath = path;
      homeModel.mantraAudioIndex = -1;
    } else {}
  }

  Future<void> filePicker(int tab) async {
    final result = await FilePicker.platform.pickFiles();
    final path = result?.files.single.path;
    setFilePath(tab, path!);
  }

  Future<void> playAudioPreview(Source mantraSoundPreviewSource) async {
    await previewPlayer.play(mantraSoundPreviewSource);
    mantraAudioModel.updatePlaybackState(true);
  }

  Future<void> pauseAudioPreview() async {
    await previewPlayer.pause();
    mantraAudioModel.updatePlaybackState(false);
  }

  Future<void> setupPreviewPlayer() async {
    previewPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.playing) {
        mantraAudioModel.updatePlaybackState(true);
      } else {
        mantraAudioPreviewIndex = -1;
        mantraAudioModel.updatePlaybackState(false);
      }
    });

    previewPlayer.onPositionChanged.listen((Duration position) async {
      Duration? totalDuration = await (previewPlayer.getDuration());
      mantraAudioModel.updatePlaybackProgress(
          position.inMilliseconds / totalDuration!.inMilliseconds);
    });
  }

  Future<void> stopAudioPreview() async {
    await previewPlayer.stop();
  }

  @override
  void initState() {
    super.initState();
    mantraAudioModel = Provider.of<MantraAudioModel>(context, listen: false);
    repetitionModel = Provider.of<RepetitionModel>(context, listen: false);
    homeModel = Provider.of<HomeModel>(context, listen: false);
    setupPreviewPlayer();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mantraAudioModel = Provider.of<MantraAudioModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Select mantra audio'),
        actions: [
          IconButton(
            //if user click this button, user can enter text based goal
            tooltip: 'Add using URL (coming soon)',
            onPressed: () {},
            icon: const Icon(Icons.keyboard_rounded),
          ),
          IconButton(
            tooltip: 'Add from file storage',
            //if user click this button, user can upload image from gallery
            onPressed: () async {
              BuildContext myContext = context;
              await filePicker(_tabController.index);
              if (myContext.mounted) {
                Navigator.pop(context, true);
              }
            },
            //getImage(ImageSource.gallery, isGuru);
            icon: const Icon(Icons.upload_file_sharp),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.maxFinite,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                      child: Text('Mantra Sound',
                          textScaleFactor:
                              ScaleSize.textScaleFactor(context) * 0.9)),
                  Tab(
                      child: Text('Cureman Talks',
                          textScaleFactor:
                              ScaleSize.textScaleFactor(context) * 0.9)),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        final bool isCurrentSongPlaying =
                            (mantraAudioPreviewIndex == index) &&
                                mantraAudioModel.isPreviewPlay;
                        return ListTile(
                          title: Text(
                            _mantraAudioList[index],
                            style: const TextStyle(color: Colors.black),
                            textScaleFactor:
                                ScaleSize.textScaleFactor(context) * 0.75,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              if (isCurrentSongPlaying) {
                                pauseAudioPreview();
                              } else {
                                mantraAudioPreviewIndex = index;
                                playAudioPreview(
                                    AssetSource(mantraAudioAssetList[index]));
                              }
                              //playPausePreview(_tabController.index, index);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  isCurrentSongPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 36.0,
                                ),
                                if (isCurrentSongPlaying)
                                  CircularProgressIndicator(
                                    value: mantraAudioModel
                                        .previewPlaybackProgress,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.orangeAccent),
                                    strokeWidth: 3.0,
                                  ),
                              ],
                            ),
                          ),
                          onTap: () {
                            homeModel.mantraAudioIndex = index;
                            homeModel.mantraAudioPath = '';
                            Navigator.pop(context, true);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                            color: Colors.grey[600],
                          ),
                      itemCount: _mantraAudioList.length),
                  ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            _mantraAudioList[index],
                            style: const TextStyle(color: Colors.black),
                            textScaleFactor:
                                ScaleSize.textScaleFactor(context) * 0.8,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.pop(context, true);
                            homeModel.mantraAudioIndex = index;
                            homeModel.mantraAudioPath = '';
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                            color: Colors.grey[600],
                          ),
                      itemCount: _mantraAudioList.length),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
