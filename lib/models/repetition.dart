import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepetitionModel extends ChangeNotifier {

  static List repList = [
    1,
    5,
    9,
    11,
    108,
    9999
  ];

  /// Internal, private state of the cart. Stores the ids of each item.
  int _selectedRepetitions = 108;
  int _remainingRepetitions = 108;

  Future<void> saveSelectedRepetitions(int reps) async {
    final prefs = await SharedPreferences.getInstance();
    selectedRepetitions = await prefs
        .setInt('selectedRepetitions', reps)
        .then((bool success) {
      return reps;
    });
  }

  Future<void> loadSelectedRepetitions() async {
    final prefs = await SharedPreferences.getInstance();
    selectedRepetitions = prefs.getInt('selectedRepetitions') ?? 108;
    notifyListeners();
  }

  Future<void> saveRemainingRepetitions(int reps) async {
    final prefs = await SharedPreferences.getInstance();
    remainingRepetitions = await prefs
        .setInt('remainingRepetitions', reps)
        .then((bool success) {
      return reps;
    });
  }

  Future<void> loadRemainingRepetitions() async {
    final prefs = await SharedPreferences.getInstance();
    remainingRepetitions = prefs.getInt('remainingRepetitions') ?? 108;
    notifyListeners();
  }

  void selectRepetitions(int reps) {
    saveSelectedRepetitions(reps);
    saveRemainingRepetitions(reps);

    selectedRepetitions = reps;
    remainingRepetitions = reps;
//    mantraAudioModel.updateMantraSoundTotalDuration(mantraAudioModel.mantraDuration * remainingRepetitions);
//    mantraAudioModel.updateMantraSoundPosition(mantraAudioModel.totalMantraDuration);
  }

  set selectedRepetitions(int reps) {
    _selectedRepetitions = reps;
    notifyListeners();
  }

  set remainingRepetitions(int reps) {
    _remainingRepetitions = reps;
    notifyListeners();
  }

  int get selectedRepetitions => _selectedRepetitions;
  int get remainingRepetitions => _remainingRepetitions;
}