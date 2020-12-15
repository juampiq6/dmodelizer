import 'dart:convert';

import 'package:dmodelizer/json_editor.dart';
import 'package:dmodelizer/meta_models/class.dart';
import 'package:dmodelizer/model_converter.dart';
import 'package:flutter/material.dart';

import 'classes_result.dart';

const encoder = const JsonEncoder.withIndent("  ");

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  bool buttonEnabled = false;
  final jsonEditorController = TextEditingController();
  final classNameController = TextEditingController();

  String validationResult = "Press button to validate";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 1, child: Center(child: Text("Dart Modelizer"))),
          Divider(
            color: Colors.black,
            thickness: 0.5,
            height: 1,
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: JsonEditor(
                      nameController: classNameController,
                      editorController: jsonEditorController,
                      onChanged: (value) {
                        if (value != "" && !buttonEnabled)
                          setState(() {
                            buttonEnabled = true;
                          });
                        else if (value == "" && buttonEnabled)
                          setState(() {
                            buttonEnabled = false;
                          });
                      },
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.amber,
                    child: ModelConverter.resultingClasses.isEmpty
                        ? Text(validationResult)
                        : ClassesResultListView(),
                  ))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: MaterialButton(
                color: Colors.green,
                child: Text("Validar"),
                onPressed: buttonEnabled ? validateJson : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  validateJson() {
    String res;
    try {
      dynamic jsonObj = json.decode(jsonEditorController.text);
      final finalText = encoder.convert(jsonObj);
      jsonEditorController.text = finalText;
      ModelConverter.parseJson(
          jsonObj,
          classNameController.text != ""
              ? classNameController.text
              : "ClassName");
      res = ModelConverter.resultingClasses
          .fold<String>("", (value, element) => value + element.toString());
    } catch (e) {
      print(e);
      res = "Validation error: \n" + e.toString();
    } finally {
      setState(() {
        validationResult = res;
      });
    }
  }
}
