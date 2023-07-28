
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';

class HomeModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.

  int _mantraAudioIndex = 0;
  String _mantraAudioPath = '';

  Future<void> saveMantraAudioIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    mantraAudioIndex = await prefs
        .setInt('mantraAudioIndex', index)
        .then((bool success) {
      return index;
    });
  }

  Future<void> loadMantraAudioIndex() async {
    final prefs = await SharedPreferences.getInstance();
    mantraAudioIndex = prefs.getInt('mantraAudioIndex') ?? 0;
    notifyListeners();
  }

  Future<void> saveMantraPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    mantraAudioPath = await prefs
        .setString('mantraAudioPath', path)
        .then((bool success) {
      return path;
    });
  }

  Future<void> loadMantraPath() async {
    final prefs = await SharedPreferences.getInstance();
    mantraAudioPath = prefs.getString('mantraAudioPath') ?? '';
    notifyListeners();
  }

  set mantraAudioIndex(int index) {
    _mantraAudioIndex = index;
    notifyListeners();
  }

  set mantraAudioPath(String path) {
    _mantraAudioPath = path;
    notifyListeners();
  }

  int get mantraAudioIndex => _mantraAudioIndex;
  String get mantraAudioPath => _mantraAudioPath;

}