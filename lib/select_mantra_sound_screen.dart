// import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spiritual_currency/common/scale_size.dart';
// import 'package:spiritual_currency/select_repetition_screen.dart';
// import 'package:spiritual_currency/set_user_variables.dart';
//
// import 'common/constants.dart';
//
// class MantraSoundModel extends ChangeNotifier {
//   Duration mantraPosition = const Duration(seconds: 0);
//   bool isPreviewPlay = false;
//   double previewPlaybackProgress = 0.0;
//   int selectedMantraSoundIndex = 0;
//   String selectedMantraSoundPath = '';
//   Duration mantraDuration = const Duration(seconds: 0);
//   Duration totalMantraDuration = const Duration(seconds: 0);
//   Source mantraSoundSource = AssetSource(mantraSoundAssetList[0]);
//
//   //Source get mantraSoundSource => _mantraSoundSource;
//   //Duration get mantraPosition => _mantraPosition;
//
//   Future<void> saveSelectedMantraSoundIndex(int mantraSoundIndex) async {
//     final prefs = await SharedPreferences.getInstance();
//     selectedMantraSoundIndex = await prefs
//         .setInt('selectedMantraSoundIndex', mantraSoundIndex)
//         .then((bool success) {
//       return mantraSoundIndex;
//     });
//   }
//
//   Future<void> loadSelectedMantraSoundIndex() async {
//     final prefs = await SharedPreferences.getInstance();
//     selectedMantraSoundIndex = prefs.getInt('selectedMantraSoundIndex') ?? 0;
//     notifyListeners();
//   }
//
//   Future<void> saveSelectedMantraSoundPath(String mantraSoundPath) async {
//     final prefs = await SharedPreferences.getInstance();
//     selectedMantraSoundPath = await prefs
//         .setString('selectedMantraSoundPath', mantraSoundPath)
//         .then((bool success) {
//       return mantraSoundPath;
//     });
//   }
//
//   Future<void> loadSelectedMantraSoundPath() async {
//     final prefs = await SharedPreferences.getInstance();
//     selectedMantraSoundPath = prefs.getString('selectedMantraSoundPath') ?? '';
//     //updateMantraSoundTotalDuration(Duration(minutes: selectedMantraSoundIndex));
//     //updateMantraSoundPosition(Duration(hours: selectedMantraSoundIndex));
//     if (selectedMantraSoundIndex == -2) {
//       //URL
//     } else if (selectedMantraSoundIndex == -1) {
//       //File
//       updateMantraSoundSource(DeviceFileSource(selectedMantraSoundPath));
//     } else {
//       updateMantraSoundSource(AssetSource(mantraSoundAssetList[selectedMantraSoundIndex]));
//     }
//     await player.setSource(mantraSoundSource);
//     Duration mantraDur = (await player.getDuration())!;
//
//     updateMantraSoundDuration(mantraDur);
//     updateMantraSoundTotalDuration(mantraDur * 1);
//     updateMantraSoundPosition(mantraDur * 1);
//     //updateMantraSoundSource(AssetSource(mantraSoundAssetList[selectedMantraSoundIndex]));
//     notifyListeners();
//   }
//
//   void updateMantraSoundPosition(Duration mantraPos) {
//     mantraPosition = mantraPos;
//     notifyListeners();
//   }
//
//   void updateMantraSoundDuration(Duration mantraDur) {
//     mantraDuration = mantraDur;
//     notifyListeners();
//   }
//
//   void updateMantraSoundTotalDuration(Duration mantraDuration) {
//     totalMantraDuration = mantraDuration;
//     notifyListeners();
//   }
//
//   void updateMantraSoundSource(Source soundSource) {
//     mantraSoundSource = soundSource;
//     //notifyListeners(); //Throws an exception, not sure why
//   }
//
//   void updatePlaybackState(bool playing) {
//     isPreviewPlay = playing;
//     notifyListeners();
//   }
//
//   void updatePlaybackProgress(double progress) {
//     previewPlaybackProgress = progress;
//     notifyListeners();
//   }
//
//   void updateStuff(int remainingReps) async {
//     if (selectedMantraSoundIndex == -2) {
//       //URL
//     } else if (selectedMantraSoundIndex == -1) {
//       //File
//       updateMantraSoundSource(DeviceFileSource(selectedMantraSoundPath));
//     } else {
//       updateMantraSoundSource(AssetSource(mantraSoundAssetList[selectedMantraSoundIndex]));
//     }
//
//     await player.setSource(mantraSoundSource);
//     Duration mantraDur = (await player.getDuration())!;
//
//     updateMantraSoundDuration(mantraDur);
//     updateMantraSoundTotalDuration(mantraDur * remainingReps);
//     updateMantraSoundPosition(mantraDur * remainingReps);
//     notifyListeners();
//   }
//
//   void selectMantraSound(int mantraSoundIndex, String mantraSoundPath, int remainingReps) async {
//     saveSelectedMantraSoundIndex(mantraSoundIndex);
//     saveSelectedMantraSoundPath(mantraSoundPath);
//     updateStuff(remainingReps);
//   }
// }
//
// class MantraSoundDialog extends StatefulWidget {
//   const MantraSoundDialog({super.key});
//
//   @override
//   State<MantraSoundDialog> createState() => _MyMantraSoundDialog();
// }
//
// class _MyMantraSoundDialog extends State<MantraSoundDialog>
//     with TickerProviderStateMixin {
//   final previewPlayer = AudioPlayer();
//   String currentSongFilePath = '';
//   late TabController _tabController;
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   String mantraSoundAsset = '';
//   final String _mantraSoundTextHint = 'Set using URL (coming soon)';
//   int mantraSoundPreviewIndex = -1;
//   late MantraSoundModel mantraSoundModel;
//   late RepetitionModel repetitionModel;
//
//   static const List _mantraSoundList = [
//     'ACBSP Hare Krishna Mantra',
//     'Shri Krishna Sharanam Mama',
//     'Om',
//   ];
//
//   void setFilePath(int tab, String path) {
//     if (path != null) {
//       if (tab == 0) {
//         mantraSoundModel.selectMantraSound(-1, path, repetitionModel.remainingRepetitions);
//       } else {
//         UserSelectedVariables.addCuremanTalksSelected(path);
//       }
//     }
//   }
//
//   void filePicker(int tab) async {
//     final result = await FilePicker.platform.pickFiles();
//     final path = result?.files.single.path;
//     setFilePath(tab, path!);
//
//   }
//
//   // void selectMantraSound(int mantraSoundIndex, String mantraSoundPath) async {
//   //   mantraSoundModel.saveSelectedMantraSoundIndex(mantraSoundIndex);
//   //   mantraSoundModel.saveSelectedMantraSoundPath(mantraSoundPath);
//   //
//   //   if (mantraSoundIndex == -2) {
//   //     //URL
//   //   } else if (mantraSoundIndex == -1) {
//   //     //File
//   //     mantraSoundModel.updateMantraSoundSource(DeviceFileSource(mantraSoundPath));
//   //   } else {
//   //     mantraSoundModel.updateMantraSoundSource(AssetSource(mantraSoundAssetList[mantraSoundIndex]));
//   //   }
//   //
//   //   await player.setSource(mantraSoundModel.mantraSoundSource);
//   //   Duration mantraDur = (await player.getDuration())!;
//   //
//   //   mantraSoundModel.updateMantraSoundDuration(mantraDur);
//   //   mantraSoundModel.updateMantraSoundTotalDuration(mantraDur * repetitionModel.remainingRepetitions);
//   //   mantraSoundModel.updateMantraSoundPosition(mantraDur * repetitionModel.remainingRepetitions);
//   // }
//
//   // void setMantraSoundSelected(int selection, String soundPath) async {
//   //   final SharedPreferences prefs = await _prefs;
//   //   mantraSoundSelected = selection;
//   //   mantraSoundPath = soundPath;
//   //   mantraSoundSelected = await prefs
//   //       .setInt('mantraSoundSelected', selection)
//   //       .then((bool success) {
//   //     return selection;
//   //   });
//   //   mantraSoundPath = await prefs
//   //       .setString('mantraSoundPath', soundPath)
//   //       .then((bool success) {
//   //     return soundPath;
//   //   });
//   //
//   //   UserSelectedVariables.setMantraSoundSource();
//   //   UserSelectedVariables.loadMantra(Provider.of<MantraSoundModel>(
//   //       context,
//   //       listen: false));
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     mantraSoundModel = Provider.of<MantraSoundModel>(context, listen: false);
//     repetitionModel = Provider.of<RepetitionModel>(context, listen: false);
//     setupPreviewPlayer();
//     _tabController = TabController(length: 2, vsync: this);
//     mantraSoundModel.loadSelectedMantraSoundIndex();
//     mantraSoundModel.loadSelectedMantraSoundPath();
//     mantraSoundModel.updateStuff(repetitionModel.remainingRepetitions);
//   }
//
// //   void playPausePreview(int tabIndex, int listIndex) async {
// // //    player.setReleaseMode(ReleaseMode.loop);
// //
// //     if (isPreviewPlay == false) {
// //       await previewPlayer.pause();
// //     } else {
// //       if (tabIndex == 0) {
// //         await previewPlayer.play(AssetSource(mantraSoundAssetList[listIndex]));
// //       } else {
// //         await previewPlayer.play(AssetSource(curemanTalksAssetList[listIndex]));
// //       }
// //     }
// //   }
//
//   Future<void> playAudioPreview(Source mantraSoundPreviewSource) async {
//     await previewPlayer.play(mantraSoundPreviewSource);
//     mantraSoundModel.updatePlaybackState(true);
//   }
//
//   Future<void> pauseAudioPreview() async {
//     await previewPlayer.pause();
//     mantraSoundModel.updatePlaybackState(false);
//   }
//
//   Future<void> setupPreviewPlayer() async {
//     previewPlayer.onPlayerStateChanged.listen((playerState) {
//       if (playerState == PlayerState.playing) {
//         mantraSoundModel.updatePlaybackState(true);
//       } else {
//         mantraSoundPreviewIndex = -1;
//         mantraSoundModel.updatePlaybackState(false);
//       }
//     });
//
//     previewPlayer.onPositionChanged.listen((Duration position) async {
//       Duration? totalDuration = await (previewPlayer.getDuration());
//       mantraSoundModel.updatePlaybackProgress(
//           position.inMilliseconds / totalDuration!.inMilliseconds);
//     });
//   }
//
//   Future<void> stopAudioPreview() async {
//     await previewPlayer.stop();
//   }
//
//   @override
//   void dispose() {
//     previewPlayer.stop();
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     mantraSoundModel = Provider.of<MantraSoundModel>(context);
//     repetitionModel = Provider.of<RepetitionModel>(context);
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       titlePadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text('Upload Sound'),
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               icon: const Icon(Icons.close),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ),
//         ],
//       ),
//       contentPadding:
//           const EdgeInsets.only(top: 0, bottom: 20, left: 5, right: 5),
//       content: SizedBox(
//             height: MediaQuery
//                 .of(context)
//                 .size
//                 .height,
//             width: double.maxFinite,
//             child: Column(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: TabBar(
//                     controller: _tabController,
//                     tabs: [
//                       Tab(
//                           child: Text('Mantra Sound',
//                               textScaleFactor:
//                               ScaleSize.textScaleFactor(context) * 0.9)),
//                       Tab(
//                           child: Text('Cureman Talks',
//                               textScaleFactor:
//                               ScaleSize.textScaleFactor(context) * 0.9)),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 10,
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       ListView.separated(
//                           itemBuilder: (BuildContext context, int index) {
//                             final bool isCurrentSongPlaying =
//                                     (mantraSoundPreviewIndex == index) &&
//                                     mantraSoundModel.isPreviewPlay;
//                             return ListTile(
//                               title: Text(
//                                 _mantraSoundList[index],
//                                 style: const TextStyle(color: Colors.black),
//                                 textScaleFactor:
//                                 ScaleSize.textScaleFactor(context) * 0.75,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               trailing: GestureDetector(
//                                 onTap: () {
//                                   if (isCurrentSongPlaying) {
//                                     pauseAudioPreview();
//                                   } else {
//                                     mantraSoundPreviewIndex = index;
//                                     playAudioPreview(AssetSource(mantraSoundAssetList[index]));
//                                   }
//                                   //playPausePreview(_tabController.index, index);
//                                 },
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Icon(
//                                       isCurrentSongPlaying
//                                           ? Icons.pause
//                                           : Icons.play_arrow,
//                                       size: 36.0,
//                                     ),
//                                     if (isCurrentSongPlaying)
//                                       CircularProgressIndicator(
//                                         value: mantraSoundModel.previewPlaybackProgress,
//                                         valueColor: const AlwaysStoppedAnimation<
//                                             Color>(
//                                             Colors.orangeAccent),
//                                         strokeWidth: 3.0,
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                               onTap: () {
//                                 mantraSoundModel.selectMantraSound(index, '', repetitionModel.remainingRepetitions);
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                                 mantraSoundAsset = mantraSoundAssetList[index];
//                                 Fluttertoast.showToast(
//                                     msg: "Updated Mantra Sound",
//                                     toastLength: Toast.LENGTH_SHORT,
//                                     gravity: ToastGravity.BOTTOM,
//                                     timeInSecForIosWeb: 1,
//                                     backgroundColor: Colors.orangeAccent,
//                                     textColor: Colors.black,
//                                     fontSize: 16.0);
//                               },
//                             );
//                           },
//                           separatorBuilder: (BuildContext context, int index) =>
//                               Divider(
//                                 color: Colors.grey[600],
//                               ),
//                           itemCount: _mantraSoundList.length),
//                       ListView.separated(
//                           itemBuilder: (BuildContext context, int index) {
//                             return ListTile(
//                               title: Text(
//                                 _mantraSoundList[index],
//                                 style: const TextStyle(color: Colors.black),
//                                 textScaleFactor:
//                                 ScaleSize.textScaleFactor(context) * 0.8,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                                 mantraSoundModel.selectMantraSound(index, '', repetitionModel.remainingRepetitions);
//                                 mantraSoundAsset = mantraSoundAssetList[index];
//                                 Fluttertoast.showToast(
//                                     msg: "Updated Mantra Sound",
//                                     toastLength: Toast.LENGTH_SHORT,
//                                     gravity: ToastGravity.BOTTOM,
//                                     timeInSecForIosWeb: 1,
//                                     backgroundColor: Colors.orangeAccent,
//                                     textColor: Colors.black,
//                                     fontSize: 16.0);
//                               },
//                             );
//                           },
//                           separatorBuilder: (BuildContext context, int index) =>
//                               Divider(
//                                 color: Colors.grey[600],
//                               ),
//                           itemCount: _mantraSoundList.length),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           width: MediaQuery
//                               .of(context)
//                               .size
//                               .width,
//                           height: MediaQuery
//                               .of(context)
//                               .size
//                               .width * 0.11,
//                           decoration: BoxDecoration(
//                             color: Colors.orangeAccent,
//                             borderRadius: BorderRadius.circular(32),
//                           ),
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: TextField(
//                                 controller: mantraSoundController,
//                                 decoration: InputDecoration.collapsed(
//                                   hintText: _mantraSoundTextHint,
//                                 ),
//                                 onEditingComplete: () {
//                                   Navigator.pop(context);
//                                   Navigator.pop(context);
//                                   if (_tabController.index == 0) {
//                                     mantraSoundModel.selectMantraSound(
//                                         -2, mantraSoundController.text, repetitionModel.remainingRepetitions);
//                                   } else {
//                                     UserSelectedVariables
//                                         .addCuremanTalksSelected(
//                                         mantraSoundController.text);
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       FloatingActionButton.small(
//                         onPressed: () {
//                           filePicker(_tabController.index);
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         },
//                         tooltip: 'Add from file storage',
//                         child: const Icon(
//                           Icons.file_upload,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }
// }
