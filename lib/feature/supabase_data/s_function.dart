import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  // Get a reference to the functions client
  final functions = Supabase.instance.client.functions;
  Future<void> testApi() async {
    final response = await functions.invoke(
      'hello-world',
      body: {'name': 'Mahmoud'},
    );
    log(name: 'function_response', response.data.toString());
  }

  // Invoke a function named 'hello-world'
}
