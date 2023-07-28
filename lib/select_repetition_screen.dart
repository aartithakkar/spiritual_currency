// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spiritual_currency/select_mantra_sound_screen.dart';
//
// // class RepetitionModel extends ChangeNotifier {
// //   int selectedRepetitions = 108;
// //   int remainingRepetitions = 108;
// //
// //   Future<void> saveSelectedRepetitions(int reps) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     selectedRepetitions = await prefs
// //         .setInt('selectedRepetitions', reps)
// //         .then((bool success) {
// //       return reps;
// //     });
// //   }
// //
// //   Future<void> loadSelectedRepetitions() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     selectedRepetitions = prefs.getInt('selectedRepetitions') ?? 108;
// //     notifyListeners();
// //   }
// //
// //   Future<void> saveRemainingRepetitions(int reps) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     remainingRepetitions = await prefs
// //         .setInt('remainingRepetitions', reps)
// //         .then((bool success) {
// //       return reps;
// //     });
// //   }
// //
// //   Future<void> loadRemainingRepetitions() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     remainingRepetitions = prefs.getInt('remainingRepetitions') ?? 108;
// //     notifyListeners();
// //   }
// //
// //   void updateSelectedRepetitions(int reps) {
// //     selectedRepetitions = reps;
// //     notifyListeners();
// //   }
// //
// //   void updateRemainingRepetitions(int reps) {
// //     remainingRepetitions = reps;
// //     notifyListeners();
// //   }
// // }
//
// class RepetitionDialog extends StatefulWidget {
//   const RepetitionDialog({super.key});
//
//   @override
//   State<RepetitionDialog> createState() => _RepetitionDialog();
// }
//
// class _RepetitionDialog extends State<RepetitionDialog> {
//   final repetitionController = TextEditingController();
//   late MantraSoundModel mantraSoundModel;
//   late RepetitionModel repetitionModel;
//
//   void selectRepetitions(int reps) {
//     repetitionModel.saveSelectedRepetitions(reps);
//     repetitionModel.saveRemainingRepetitions(reps);
//
//     repetitionModel.updateSelectedRepetitions(reps);
//     repetitionModel.updateRemainingRepetitions(reps);
//     mantraSoundModel.updateMantraSoundTotalDuration(mantraSoundModel.mantraDuration * repetitionModel.remainingRepetitions);
//     mantraSoundModel.updateMantraSoundPosition(mantraSoundModel.totalMantraDuration);
//   }
//
//   @override
//   void initState() {
//     repetitionModel = Provider.of<RepetitionModel>(context, listen: false);
//     super.initState();
//     repetitionModel.loadSelectedRepetitions();
//     repetitionModel.loadRemainingRepetitions();
//   }
//
//
//   @override
//   void dispose() {
//     repetitionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     mantraSoundModel = Provider.of<MantraSoundModel>(context);
//     repetitionModel = Provider.of<RepetitionModel>(context);
//     repetitionController.clear();
//     return AlertDialog(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         titlePadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Select my repetitions'),
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ),
//           ],
//         ),
//         contentPadding:
//         const EdgeInsets.only(top: 0, bottom: 20, left: 5, right: 5),
//         content: SizedBox(
//           height: MediaQuery.of(context).size.height / 2,
//           width: double.maxFinite,
//           child: Column(
//             children: [
//               ElevatedButton(
//                 //if user click this button, user can upload image from gallery
//                 onPressed: () {
//                   selectRepetitions(1);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('1'),
//               ),
//               ElevatedButton(
//                 //if user click this button, user can upload image from gallery
//                 onPressed: () {
//                   selectRepetitions(5);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('5'),
//               ),
//               ElevatedButton(
//                 //if user click this button, user can upload image from gallery
//                 onPressed: () {
//                   selectRepetitions(9);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('9'),
//               ),
//               ElevatedButton(
//                 //if user click this button, user can upload image from gallery
//                 onPressed: () {
//                   selectRepetitions(11);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('11'),
//               ),
//               ElevatedButton(
//                 //if user click this button, user can upload image from gallery
//                 onPressed: () {
//                   selectRepetitions(108);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('108'),
//               ),
//               ElevatedButton(
//                 //if user click this button, user can upload image from gallery
//                 onPressed: () {
//                   selectRepetitions(99999);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Infinite'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.orangeAccent,
//                     borderRadius: BorderRadius.circular(32),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: repetitionController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                       decoration: const InputDecoration.collapsed(
//                         hintText: 'Type my repetitions',
//                       ),
//                       onEditingComplete: () {
//                         int recitations = int.parse(repetitionController.text);
//                         recitations = recitations > 0 ? (recitations > 99999 ? 99999 : recitations) : 108;
//                         Navigator.pop(context);
//                         selectRepetitions(recitations);
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );
//   }
// }
