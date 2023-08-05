import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spiritual_currency/models/mantra.dart';

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
      appBar: AppBar(
        title: const Text('Select my mantra'),
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.11,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: mantraController,
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Type my mantra',
                            ),
                            onEditingComplete: () {
                              Navigator.pop(context);
                              mantraModel.selectMantra(mantraController.text);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}