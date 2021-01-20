import 'dart:convert';

import 'package:dmodelizer/json_editor.dart';
import 'package:dmodelizer/meta_models/class.dart';
import 'package:dmodelizer/providers/model_converter_prov.dart';
import 'package:dmodelizer/providers/providers_declaration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'classes_result.dart';

const encoder = const JsonEncoder.withIndent("  ");

class Home extends StatelessWidget {
  final jsonEditorController = TextEditingController();
  final classNameController = TextEditingController();

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
                    child: Consumer(
                      builder: (_, watch, child) {
                        final prov = watch(modelConverterProvider);
                        return JsonEditor(
                          nameController: classNameController,
                          editorController: jsonEditorController,
                          onChanged: (value) {
                            if (value != "" && !prov.validateButtonEnabled)
                              prov.validateButtonEnabled = true;
                            else if (value == "" && prov.validateButtonEnabled)
                              prov.validateButtonEnabled = false;
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.amber,
                    child: ClassesResultListView(),
                  ))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Consumer(builder: (_, watch, child) {
              final prov = watch(modelConverterProvider);
              return Row(
                children: [
                  Container(
                    child: MaterialButton(
                      color: Colors.green,
                      child: Text("Validar"),
                      onPressed: prov.validateButtonEnabled
                          ? () {
                              jsonEditorController.text = prov.validateJson(
                                  jsonEditorController.text,
                                  classNameController.text);
                            }
                          : null,
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      color: Colors.green,
                      child: Text("Generar código Dart"),
                      onPressed:
                          prov.validateButtonEnabled && !prov.validationError
                              ? () {
                                  showGeneratedCode(context);
                                }
                              : null,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void showGeneratedCode(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Scaffold(
                          body: Container(
                child: Consumer(
                  builder: (_, watch, child) {
                    final prov = watch(modelConverterProvider);
                    return DefaultTabController(
                      length: prov.resultingClasses.length,
                      child: Column(
                        children: [
                          TabBar(
                              tabs: prov.resultingClasses
                                  .map((e) => Tab(text: e.name))
                                  .toList()),
                          Expanded(
                                                      child: TabBarView(
                              children: prov.resultingClasses
                                  .map((e) => Text(e.toCode()))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}
