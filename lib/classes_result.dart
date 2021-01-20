import 'package:dmodelizer/meta_models/class.dart';
import 'package:dmodelizer/providers/model_converter_prov.dart';
import 'package:dmodelizer/providers/providers_declaration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'type_selector.dart';

class ClassesResultListView extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final prov = watch(modelConverterProvider);
    final List<Class> classes = prov.resultingClasses.toList();
    
    return classes.isEmpty ? Text(prov.validationResult) : ListView.separated(
      itemCount: classes.length,
      itemBuilder: (_, i) => ExpansionTile(
        childrenPadding: EdgeInsets.all(20),
        title: Text(classes[i].name),
        children: classes[i]
            .attributes
            .map((a) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(a.name),
                SizedBox(width: 15,),
                TypeSelector(a)
              ],
            ))
            .toList(),
      ),
      separatorBuilder: (_, __) => Divider(),
    );
  }
}
