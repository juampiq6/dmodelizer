import 'package:dmodelizer/meta_models/class_attribute.dart';

class Class {
  final String name;
  final Set<ClassAttribute> attributes;

  Class({this.name, this.attributes});

  @override
  String toString() {
    return "\nC -> $name \n ${attributes.fold("", (str, e) => str + e.toString())}";
  }
}