import 'package:dmodelizer/meta_models/class_attribute.dart';
import 'package:recase/recase.dart';

class Class extends Type {
  final String name;
  final String nameInJson;
  final Set<ClassAttribute> attributes;

  Class({this.name, this.attributes, this.nameInJson});

  @override
  String toString() {
    return "\nC -> $name \n ${attributes.fold("", (str, e) => str + e.toString())}";
  }

  String toCode() {
    return _initClass([_addAttributes(), _addConstructor(), _addToJson()]);
  }

  String _initClass(List<String> classInternals) =>
      "class $name { \n ${classInternals.join("\n")} \n }";
  String _addAttributes() =>
      attributes.map((a) => "\n    ${a.type == Class ? a.name.pascalCase : a.type.toString()} ${a.name};").join("");
  String _addConstructor() =>
      "\n    $name({${attributes.map((a) => " this.${a.name}").join(",")}});\n";
  String _addToJson() => """
    Map<String, dynamic> toJson() =>
      {
${attributes.map((a) => '      "${a.name}": ${a.name}${a.type == DateTime ? '.toIso8601String()' : a.type == Class ? '.toJson()' : ''}').join(",\n")}
      }
    """;
}
