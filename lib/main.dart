import 'package:flutter/material.dart';

import 'app/view/flstash_app.dart';
import 'common/logging.dart';
import 'register.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogging();
  registerDependencies();
  runApp(const FlstashApp());
}
