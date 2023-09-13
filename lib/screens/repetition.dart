import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cureman/models/repetition.dart';

import '../common/scale_size.dart';

class MyRepetition extends StatefulWidget {
  const MyRepetition({super.key});

  @override
  State<MyRepetition> createState() => _MyRepetition();
}

class _MyRepetition extends State<MyRepetition> {
  final repetitionController = TextEditingController();
  late RepetitionModel repetitionModel;

  @override
  void dispose() {
    repetitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    repetitionModel = Provider.of<RepetitionModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Select my repetitions'),
        actions: [
          IconButton(
            //if user click this button, user can enter text based goal
            tooltip: 'Type my repetition',
            onPressed: () {
              _openInputDialog(context);
            },
            icon: const Icon(Icons.keyboard_rounded),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          RepetitionModel.repList[index].toString(),
                          style: const TextStyle(color: Colors.black),
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pop(context, true);
                          repetitionModel.selectRepetitions(
                              RepetitionModel.repList[index]);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          color: Colors.grey[600],
                        ),
                    itemCount: RepetitionModel.repList.length),
              ),
            ],
          ),
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
            controller: repetitionController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Type my repetition'),
            onEditingComplete: () {
              if (repetitionController.text != '') {
                int recitations = int.parse(repetitionController.text);
                recitations = recitations > 0
                    ? (recitations > 99999 ? 99999 : recitations)
                    : 108;
                Navigator.pop(context);
                Navigator.pop(context, true);
                repetitionModel.selectRepetitions(recitations);
                repetitionController.clear();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                repetitionController.clear();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the entered text here
                if (repetitionController.text != '') {
                  int recitations = int.parse(repetitionController.text);
                  recitations = recitations > 0
                      ? (recitations > 99999 ? 99999 : recitations)
                      : 108;
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  repetitionModel.selectRepetitions(recitations);
                  repetitionController.clear();
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
