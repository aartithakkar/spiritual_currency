import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spiritual_currency/models/mentor.dart';

import '../components/image_content.dart';

class MyMentor extends StatefulWidget {
  const MyMentor({super.key});

  @override
  State<MyMentor> createState() => _MyMentor();
}

class _MyMentor extends State<MyMentor> {
  late MentorModel mentorModel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mentorModel = Provider.of<MentorModel>(context, listen: false);
    final PageController controller = PageController();
    int pageChanged = 0;
    int listLength = MentorModel.mentorImgList.length;
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select my mentor'),
        actions: [
          IconButton(
            //if user click this button, user can upload image from gallery
            onPressed: () async {
              BuildContext myContext = context;
              var img = await picker.pickImage(source: ImageSource.gallery);
              if (img != null) {
                mentorModel.mentorImagePath = img.path;
                mentorModel.mentorImageIndex = -1;
                if (myContext.mounted) {
                  Navigator.pop(context, true);
                }
              } else {
                if (myContext.mounted) {
                  //  Navigator.pop(context, false);
                }
              }
              //getImage(ImageSource.gallery, isGuru);
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
                                        MentorModel.mentorImgList[i].imagePath),
                                    label: ''),
                              ),
                            ),
                            Expanded(
                                child: Text(
                                    MentorModel.mentorImgList[i].imageCaption)),
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
                  mentorModel.mentorImageIndex = pageChanged;
                  mentorModel.mentorImagePath = '';
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
