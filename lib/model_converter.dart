import 'package:dmodelizer/meta_models/class.dart';
import 'package:dmodelizer/meta_models/class_attribute.dart';
import 'dart:convert';

class ModelConverter {
  static final resultingClasses = Set<Class>();
  static parseJson(dynamic json, String mainClassName) {
    resultingClasses.clear();
    if (json is List) {
      print("error json es lista");
    } else {
      resultingClasses
          .add(Class(name: mainClassName, attributes: parseClass(json)));
    }
  }

  static ClassAttribute getClassAttributeType(String name, dynamic value) {
    switch (value.runtimeType) {
      case String:
        final date = DateTime.tryParse(value);
        if(date != null)
          return ClassAttribute.dateTime(DateTime, name);
        else
          return ClassAttribute.primitive(String, name);
        break;
      case bool:
      case int:
      case double:
        return ClassAttribute.primitive(value.runtimeType, name);
        break;
      case List:
        return ClassAttribute.collection(List, name);
        break;
      default:
        return ClassAttribute.model(name);
    }
  }

  static Set<ClassAttribute> parseClass(Map<String, dynamic> map) {
    try {
      final attrSet = Set<ClassAttribute>();
      for (var k in map.keys) {
        final attr = getClassAttributeType(k, map[k]);
        if (attr.isComplex) {
          resultingClasses.add(Class(name: k, attributes: parseClass(map[k])));
        }
        attrSet.add(attr);
      }
      return attrSet;
    } catch (e) {
      print(e);
      throw Exception("Unsupported runtime type -> ${map.runtimeType}");
    }
  }
}
