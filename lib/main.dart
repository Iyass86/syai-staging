import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_oauth_chat/app/bindings/initial_binding.dart';
import 'package:flutter_oauth_chat/app/core/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await GetStorage.init();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhuY29kc2RsbHJxb2Rpcm1hYWNzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg2NzExMDcsImV4cCI6MjA2NDI0NzEwN30.dKgbc3F26s1OPFZHips6r1Z5kkGGAa4ZVQfaJBvB1rg',
  );
  InitialBinding().dependencies();
  runApp(const App());
}
