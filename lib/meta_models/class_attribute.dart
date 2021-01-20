import 'package:dmodelizer/meta_models/class.dart';

const supportedTypes = <Type>{String, bool, int, double, List, DateTime };
class ClassAttribute {
  Type type;
  final String name;

  bool get isComplex => type == Class;

  ClassAttribute.primitive(this.type, this.name)
      : assert(type == bool || type == String || type == int || type == double);

  ClassAttribute.collection(this.type,this.name)
      : assert(type == List);
      
  ClassAttribute.dateTime(this.name)
      : this.type = DateTime;

  ClassAttribute.model(this.name)
      : this.type = Class;

  @override
  String toString() {
    return "$name -> ${type.toString()}\n";
  }
}
