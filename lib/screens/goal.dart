import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spiritual_currency/models/goal.dart';

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
      appBar: AppBar(title: const Text('Select my goal'),),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.maxFinite,
        child: Column(
          children: [
            ElevatedButton(
              //if user click this button, user can upload image from gallery
              onPressed: () async {
                BuildContext myContext = context;
                var img = await picker.pickImage(source: ImageSource.gallery);
                if (img != null) {
                  goalModel.goalImagePath = img.path;
                  goalModel.goalImageIndex = -1;
                  goalModel.goalText = '';
                  if(myContext.mounted) {
                    Navigator.pop(context, true);
                  }
                } else {
                  if(myContext.mounted) {
                    Navigator.pop(context, false);
                  }
                }
                //getImage(ImageSource.gallery, isGuru);
              },
              child: const Row(
                children: [
                  Icon(Icons.image),
                  Text('From Gallery'),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: PageView(
                  controller: controller,
                  children: [
                    for (var i = 0; i < listLength; i++)
                      Center(
                        child: Column(
                          children: [
                            Expanded(child: Image.asset(GoalModel.goalImgList[i].imagePath)),
                            Expanded(child: Text(GoalModel.goalImgList[i].imageCaption)),
                          ],
                        ),
                      ),
                  ],
                  onPageChanged: (index) {
                    // setState(() {
                    pageChanged = index;
                    // });
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: goalTextController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type my goal',
                    ),
                    onEditingComplete: () {
                      if (goalTextController.text != '') {
                        Navigator.pop(context, true);
                        goalModel.goalImageIndex = -2;
                        goalModel.goalImagePath = '';
                        goalModel.goalText = goalTextController.text;
                      } else {
                        Navigator.pop(context, false);
                      }
                      //goalText = myController.text;
                      //lordImage = null;
                      //lordImageSelected = -1;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}