import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model_converter_prov.dart';

final modelConverterProvider = ChangeNotifierProvider<ModelConverter>((x) => ModelConverter());
