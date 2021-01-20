import 'package:flutter/material.dart';

class JsonEditor extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController nameController;
  final TextEditingController editorController;

  const JsonEditor(
      {Key key, this.onChanged, this.nameController, this.editorController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: "Class Name: "),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: Colors.teal,width: 0.5), borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: editorController,
              onChanged: onChanged,
              autofocus: true,
              expands: true,
              maxLines: null,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Paste or write source JSON here"),
            ),
          ),
        ),
      ],
    );
  }
}
