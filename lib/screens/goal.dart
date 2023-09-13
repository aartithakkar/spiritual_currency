import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spiritual_currency/models/goal.dart';

import '../components/image_content.dart';

class MyGoal extends StatefulWidget {
  const MyGoal({super.key});

  @override
  State<MyGoal> createState() => _MyGoal();
}

class _MyGoal extends State<MyGoal> {
  late GoalModel goalModel;
  final goalTextController = TextEditingController();

  @override
  void dispose() {
    goalTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    goalModel = Provider.of<GoalModel>(context, listen: false);
    final PageController controller = PageController();
    int pageChanged = 0;
    int listLength = GoalModel.goalImgList.length;
    final ImagePicker picker = ImagePicker();

    goalTextController.clear();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Select my goal'),
        actions: [
          IconButton(
            //if user click this button, user can enter text based goal
            tooltip: 'Type my goal',
            onPressed: () {
              _openInputDialog(context);
            },
            icon: const Icon(Icons.keyboard_rounded),
          ),
          IconButton(
            tooltip: 'Open photo gallery',
            //if user click this button, user can upload image from gallery
            onPressed: () async {
              BuildContext myContext = context;
              var img = await picker.pickImage(source: ImageSource.gallery);
              if (img != null) {
                goalModel.goalImagePath = img.path;
                goalModel.goalImageIndex = -1;
                goalModel.goalText = '';
                if (myContext.mounted) {
                  Navigator.pop(context, true);
                }
              } else {
                if (myContext.mounted) {
                  //  Navigator.pop(context, false);
                }
              }
            },
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                child: PageView(
                  controller: controller,
                  children: [
                    for (var i = 0; i < listLength; i++)
                      Center(
                        child: Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width,
                                width:
                                    MediaQuery.of(context).size.width * 9 / 14,
                                child: ImageContent(
                                    displayImage: AssetImage(
                                        GoalModel.goalImgList[i].imagePath),
                                    label: ''),
                              ),
                            ),
                            Expanded(
                              child:
                                  Text(GoalModel.goalImgList[i].imageCaption),
                            ),
                          ],
                        ),
                      ),
                  ],
                  onPageChanged: (index) {
                    pageChanged = index;
                  },
                ),
                onTap: () {
                  //add set state if doesn't get detected on each press
                  Navigator.pop(context, true);
                  goalModel.goalImageIndex = pageChanged;
                  goalModel.goalImagePath = '';
                  goalModel.goalText = '';
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: TextField(
              controller: goalTextController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Type my goal'),
              onEditingComplete: () {
                if (goalTextController.text != '') {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  goalModel.goalImageIndex = -2;
                  goalModel.goalImagePath = '';
                  goalModel.goalText = goalTextController.text;
                  goalTextController.clear();
                } else {
                  Navigator.pop(context);
                }
              }),
          actions: [
            TextButton(
              onPressed: () {
                goalTextController.clear();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the entered text here
                if (goalTextController.text != '') {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  goalModel.goalImageIndex = -2;
                  goalModel.goalImagePath = '';
                  goalModel.goalText = goalTextController.text;
                  goalTextController.clear();
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
