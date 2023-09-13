import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cureman/components/image_content.dart';


class MentorModel extends ChangeNotifier {
  static List<ImageData> mentorImgList = [
    ImageData('assets/graphics/SP.jpeg', 'A.C. Bhaktivedanta Swami Prabhupada'),
    ImageData('assets/graphics/SV.jpeg', 'Srimad Vallabhacharya'),
    ImageData('assets/graphics/SP.jpeg', 'A.C. Bhaktivedanta Swami Prabhupada'),
    ImageData('assets/graphics/SV.jpeg', 'Srimad Vallabhacharya'),
  ];

  int _mentorImageIndex = 0;
  String _mentorImagePath = '';

  Future<void> saveMentorImageIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    mentorImageIndex = await prefs
        .setInt('mentorImageIndex', index)
        .then((bool success) {
      return index;
    });
  }

  Future<void> loadMentorImageIndex() async {
    final prefs = await SharedPreferences.getInstance();
    mentorImageIndex = prefs.getInt('mentorImageIndex') ?? 0;
    notifyListeners();
  }

  Future<void> saveMentorImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    mentorImagePath = await prefs
        .setString('mentorImagePath', path)
        .then((bool success) {
      return path;
    });
  }

  Future<void> loadMentorImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    mentorImagePath = prefs.getString('mentorImagePath') ?? '';
    notifyListeners();
  }

  set mentorImageIndex(int index) {
    _mentorImageIndex = index;
    notifyListeners();
  }

  set mentorImagePath(String path) {
    _mentorImagePath = path;
    notifyListeners();
  }

  int get mentorImageIndex => _mentorImageIndex;
  String get mentorImagePath => _mentorImagePath;
}