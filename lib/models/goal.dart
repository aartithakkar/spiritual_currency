import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cureman/components/image_content.dart';

class GoalModel extends ChangeNotifier {
  static List<ImageData> goalImgList = [
    ImageData('assets/graphics/SP.jpeg', 'A.C. Bhaktivedanta Swami Prabhupada'),
    ImageData('assets/graphics/SV.jpeg', 'Srimad Vallabhacharya'),
    ImageData('assets/graphics/Gaur_Nitai.jpeg', 'Gauranga Nityananda'),
    ImageData('assets/graphics/SV.jpeg', 'Srimad Mahaprabhu'),
  ];

  int _goalImageIndex = -2;
  String _goalImagePath = '';
  String _goalText = 'My Goal';

  Future<void> saveGoalImageIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    goalImageIndex = await prefs
        .setInt('goalImageIndex', index)
        .then((bool success) {
      return index;
    });
  }

  Future<void> loadGoalImageIndex() async {
    final prefs = await SharedPreferences.getInstance();
    goalImageIndex = prefs.getInt('goalImageIndex') ?? 0;
    notifyListeners();
  }

  Future<void> saveGoalImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    goalImagePath = await prefs
        .setString('goalImagePath', path)
        .then((bool success) {
      return path;
    });
  }

  Future<void> loadGoalImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    goalImagePath = prefs.getString('goalImagePath') ?? '';
    notifyListeners();
  }

  Future<void> saveGoalText(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    goalText = await prefs
        .setString('goalText', goal)
        .then((bool success) {
      return goal;
    });
  }

  Future<void> loadGoalText() async {
    final prefs = await SharedPreferences.getInstance();
    goalText = prefs.getString('goalText') ?? 'My goal';
    notifyListeners();
  }

  set goalImageIndex(int index) {
    _goalImageIndex = index;
    notifyListeners();
  }

  set goalImagePath(String path) {
    _goalImagePath = path;
    notifyListeners();
  }

  set goalText(String goal) {
    _goalText = goal;
    notifyListeners();
  }

  int get goalImageIndex => _goalImageIndex;
  String get goalImagePath => _goalImagePath;
  String get goalText => _goalText;
}