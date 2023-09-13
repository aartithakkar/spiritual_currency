import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MantraModel extends ChangeNotifier {
  static List mantraList = [
    'Hare Krishna Hare Krishna Krishna Krishna Hare Hare Hare Rama Hare Rama Rama Rama Hare Hare',
    'Shri Krishna Sharanam Mama',
    'Om',
  ];

  String _selectedMantra = 'My Mantra';

  Future<void> saveSelectedMantra(String mantra) async {
    final prefs = await SharedPreferences.getInstance();
    selectedMantra =
        await prefs.setString('selectedMantra', mantra).then((bool success) {
      return mantra;
    });
  }

  Future<void> loadSelectedMantra() async {
    final prefs = await SharedPreferences.getInstance();
    selectedMantra = prefs.getString('selectedMantra') ?? 'My mantra';
    notifyListeners();
  }

  void selectMantra(String mantra) {
    if (mantra == '') {
      return;
    }
    saveSelectedMantra(mantra);

    selectedMantra = mantra;
  }

  // void setMantraSelected(String mantra) async {
  //   if (mantra == '') {
  //     return;
  //   }
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   selectedMantra = mantra;
  //   selectedMantra =
  //   await prefs.setString('userMantra', selectedMantra).then((bool success) {
  //     return selectedMantra;
  //   });
  //   notifyListeners();
  // }

  set selectedMantra(String mantra) {
    _selectedMantra = mantra;
    notifyListeners();
  }

  String get selectedMantra => _selectedMantra;
}
