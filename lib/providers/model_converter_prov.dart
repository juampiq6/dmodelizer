import 'dart:convert';

import 'package:dmodelizer/meta_models/class.dart';
import 'package:dmodelizer/meta_models/class_attribute.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';

import 'package:flutter/cupertino.dart';

class ModelConverter extends ChangeNotifier {
  static const _encoder = const JsonEncoder.withIndent("  ");
  final resultingClasses = Set<Class>();
  String validationResult = "Press button to validate";
  bool validationError = false;
  bool _validateButtonEnabled = false;

  bool get validateButtonEnabled => _validateButtonEnabled;
  set validateButtonEnabled(bool b) {
    _validateButtonEnabled = b;
    notifyListeners();
  }

  String validateJson(String jsonString, String className) {
    String finalText;
    try {
      dynamic jsonObj = json.decode(jsonString);
      finalText = _encoder.convert(jsonObj);
      parseJson(jsonObj, className != "" ? className : "ClassName");
      validationResult = resultingClasses.fold<String>(
          "", (value, element) => value + element.toString());
    } catch (e) {
      print(e);
      validationError = true;
      validationResult = "Validation error: \n" + e.toString();
    }
    return validationError ? null : finalText;
  }

  void parseJson(dynamic json, String mainClassName) {
    resultingClasses.clear();
    if (json is List) {
      print("error json es lista");
    } else {
      resultingClasses
          .add(Class(name: mainClassName, attributes: parseClass(json)));
      notifyListeners();
    }
  }

  ClassAttribute getClassAttributeType(String name, dynamic value) {
    name = name.camelCase;
    switch (value.runtimeType) {
      case String:
        final date = DateTime.tryParse(value);
        if (date != null)
          return ClassAttribute.dateTime(name);
        else
          return ClassAttribute.primitive(String, name);
        break;
      case bool:
      case int:
      case double:
        return ClassAttribute.primitive(value.runtimeType, name);
        break;
      case List:
        // print();
        // (value as List).
        return ClassAttribute.collection(List, name);
        break;
      default:
        return ClassAttribute.model(name);
    }
  }

  Set<ClassAttribute> parseClass(Map<String, dynamic> map) {
    try {
      final attrSet = Set<ClassAttribute>();
      for (var k in map.keys) {
        final attr = getClassAttributeType(k, map[k]);
        if (attr.isComplex) {
          resultingClasses.add(Class(name: k.pascalCase, attributes: parseClass(map[k])));
        }
        attrSet.add(attr);
      }
      return attrSet;
    } catch (e) {
      print(e);
      throw Exception("Unsupported runtime type -> ${map.runtimeType}");
    }
  }

  String generateCode(Class c) {
    return c.toCode();
  }
}
