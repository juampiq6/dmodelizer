import 'package:dmodelizer/meta_models/class.dart';
import 'package:dmodelizer/model_converter.dart';
import 'package:flutter/material.dart';

class ClassesResultListView extends StatelessWidget {
  final List<Class> classes = ModelConverter.resultingClasses.toList();

  @override
  Widget build(BuildContext context) {
    
    return ListView.separated(
      itemCount: classes.length,
      itemBuilder: (_, i) => ExpansionTile(
        childrenPadding: EdgeInsets.all(20),
        title: Text(classes[i].name),
        children: classes[i]
            .attributes
            .map((a) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(a.name),
                Text(a.type.toString())
              ],
            ))
            .toList(),
      ),
      separatorBuilder: (_, __) => Divider(),
    );
  }
}
