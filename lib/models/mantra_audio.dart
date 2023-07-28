import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';

class MantraAudioModel extends ChangeNotifier {
  bool isPreviewPlay = false;
  double previewPlaybackProgress = 0.0;



  // Future<void> loadSelectedMantraSoundPath() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   selectedMantraSoundPath = prefs.getString('selectedMantraSoundPath') ?? '';
  //   //updateMantraSoundTotalDuration(Duration(minutes: selectedMantraSoundIndex));
  //   //updateMantraSoundPosition(Duration(hours: selectedMantraSoundIndex));
  //   if (selectedMantraSoundIndex == -2) {
  //     //URL
  //   } else if (selectedMantraSoundIndex == -1) {
  //     //File
  //     updateMantraSoundSource(DeviceFileSource(selectedMantraSoundPath));
  //   } else {
  //     updateMantraSoundSource(AssetSource(mantraAudioAssetList[selectedMantraSoundIndex]));
  //   }
  //   await player.setSource(mantraSoundSource);
  //   Duration mantraDur = (await player.getDuration())!;
  //
  //   updateMantraSoundDuration(mantraDur);
  //   updateMantraSoundTotalDuration(mantraDur * 1);
  //   updateMantraSoundPosition(mantraDur * 1);
  //   //updateMantraSoundSource(AssetSource(mantraSoundAssetList[selectedMantraSoundIndex]));
  //   notifyListeners();
  // }


  void updatePlaybackState(bool playing) {
    isPreviewPlay = playing;
    notifyListeners();
  }

  void updatePlaybackProgress(double progress) {
    previewPlaybackProgress = progress;
    notifyListeners();
  }

  // void updateStuff(int remainingReps) async {
  //   if (selectedMantraSoundIndex == -2) {
  //     //URL
  //   } else if (selectedMantraSoundIndex == -1) {
  //     //File
  //     updateMantraSoundSource(DeviceFileSource(selectedMantraSoundPath));
  //   } else {
  //     updateMantraSoundSource(AssetSource(mantraAudioAssetList[selectedMantraSoundIndex]));
  //   }
  //
  //   await player.setSource(mantraSoundSource);
  //   Duration mantraDur = (await player.getDuration())!;
  //
  //   updateMantraSoundDuration(mantraDur);
  //   updateMantraSoundTotalDuration(mantraDur * remainingReps);
  //   updateMantraSoundPosition(mantraDur * remainingReps);
  //   notifyListeners();
  // }
  //
  // void selectMantraAudio(int mantraSoundIndex, String mantraSoundPath, int remainingReps) async {
  //   saveSelectedMantraSoundIndex(mantraSoundIndex);
  //   saveSelectedMantraSoundPath(mantraSoundPath);
  //   updateStuff(remainingReps);
  // }
}