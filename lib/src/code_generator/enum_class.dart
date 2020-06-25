// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

import 'binding.dart';
import 'binding_string.dart';
import 'writer.dart';

/// A binding for enums in C.
///
/// For a C enum -
/// ```c
/// enum Fruits {apple, banana = 10};
/// ```
/// The generated dart code is
///
/// ```dart
/// class Fruits {
///   static const apple = 0;
///   static const banana = 10;
/// }
/// ```
class EnumClass extends Binding {
  final List<EnumConstant> enumConstants;

  EnumClass({
    @required String name,
    String dartDoc,
    List<EnumConstant> enumConstants,
  })  : enumConstants = enumConstants ?? [],
        super(name: name, dartDoc: dartDoc);

  @override
  BindingString toBindingString(Writer w) {
    final s = StringBuffer();

    if (dartDoc != null) {
      s.write('/// ');
      s.writeAll(dartDoc.split('\n'), '\n/// ');
      s.write('\n');
    }

    // Print enclosing class.
    s.write('class $name {\n');
    const depth = '  ';
    for (final ec in enumConstants) {
      if (ec.dartDoc != null) {
        s.write(depth + '/// ');
        s.writeAll(ec.dartDoc.split('\n'), '\n' + depth + '/// ');
        s.write('\n');
      }
      s.write(depth + 'static const int ${ec.name} = ${ec.value};\n');
    }
    s.write('}\n\n');

    return BindingString(
        type: BindingStringType.enumClass, string: s.toString());
  }
}

/// Represents a single value in an enum.
class EnumConstant {
  final String dartDoc;
  final String name;
  final int value;
  const EnumConstant({@required this.name, @required this.value, this.dartDoc});
}