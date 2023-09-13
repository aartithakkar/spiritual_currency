import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cureman/models/mantra.dart';

import '../common/scale_size.dart';

class MyMantra extends StatefulWidget {
  const MyMantra({super.key});

  @override
  State<MyMantra> createState() => _MyMantra();
}

class _MyMantra extends State<MyMantra> {
  final mantraController = TextEditingController();
  late MantraModel mantraModel;

  @override
  void dispose() {
    mantraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mantraModel = Provider.of<MantraModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Select my mantra'),
        actions: [
          IconButton(
            //if user click this button, user can enter text based goal
            tooltip: 'Type my mantra',
            onPressed: () {
              _openInputDialog(context);
            },
            icon: const Icon(Icons.keyboard_rounded),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          MantraModel.mantraList[index],
                          style: const TextStyle(color: Colors.black),
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          mantraModel
                              .selectMantra(MantraModel.mantraList[index]);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          color: Colors.grey[600],
                        ),
                    itemCount: MantraModel.mantraList.length),
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
              controller: mantraController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Type my mantra'),
              onEditingComplete: () {
                Navigator.pop(context);
                Navigator.pop(context);
                mantraModel.selectMantra(mantraController.text);
                mantraController.clear();
              }),
          actions: [
            TextButton(
              onPressed: () {
                mantraController.clear();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the entered text here
                Navigator.pop(context);
                Navigator.pop(context);
                mantraModel.selectMantra(mantraController.text);
                mantraController.clear();
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
