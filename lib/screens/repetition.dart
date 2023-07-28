import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spiritual_currency/models/repetition.dart';

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
      appBar: AppBar(title: const Text('Select my repetitions'),),
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
                          textScaleFactor:
                          ScaleSize.textScaleFactor(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pop(context, true);
                          repetitionModel.selectRepetitions(RepetitionModel.repList[index]);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          color: Colors.grey[600],
                        ),
                    itemCount: RepetitionModel.repList.length),
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
                            controller: repetitionController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Type my repetition',
                            ),
                            onEditingComplete: () {
                              int recitations = int.parse(repetitionController.text);
                              recitations = recitations > 0 ? (recitations > 99999 ? 99999 : recitations) : 108;
                              Navigator.pop(context, true);
                              repetitionModel.selectRepetitions(recitations);
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