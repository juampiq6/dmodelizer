import 'package:dmodelizer/meta_models/class.dart';

class ClassAttribute {
  final Type type;
  final String name;

  bool get isComplex => type == Class;

  ClassAttribute.primitive(this.type, this.name)
      : assert(type == bool || type == String || type == int || type == double);

  ClassAttribute.dateTime(this.type, this.name)
      : assert(type == DateTime);

  ClassAttribute.collection(this.type, this.name)
      : assert(type == List);

  ClassAttribute.model(this.name)
      : this.type = Class;

  @override
  String toString() {
    return "$name -> ${type.toString()}\n";
  }
}
