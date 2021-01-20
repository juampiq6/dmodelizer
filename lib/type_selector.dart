import 'meta_models/class_attribute.dart';
import 'package:flutter/material.dart';
import 'meta_models/class.dart';

class TypeSelector extends StatefulWidget {
  final ClassAttribute originalAttr;
  TypeSelector(this.originalAttr);

  @override
  _TypeSelectorState createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<TypeSelector> {
  ClassAttribute currentAttr;
  @override
  void initState() {
    super.initState();
    currentAttr = widget.originalAttr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<Type>(
        onChanged: (t) {
          setState(() {
            currentAttr.type = t;
          });
        },
        isDense: true,
        value: currentAttr.type,
        items: widget.originalAttr.type != Class
            ? supportedTypes
                .map((e) => DropdownMenuItem<Type>(
                      value: e,
                      child: Text(e.toString()),
                    ))
                .toList()
            : [
                DropdownMenuItem<Type>(
                  value: Class,
                  child: Text("Model"))
              ],
      ),
    );
  }
}
