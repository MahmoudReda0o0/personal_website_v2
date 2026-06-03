import 'dart:developer';

import 'package:personal_website_v2/core/model/personal_info.dart';
import 'package:personal_website_v2/core/model/setting_model.dart';
import 'package:personal_website_v2/feature/supabase_data/s_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabase {
  SupabaseDatabase._();
  static final SupabaseDatabase instance = SupabaseDatabase._();
  static final supabase = Supabase.instance.client;
  final database = Supabase.instance.client.from(
    SupabaseConfig.tablePersonalInfo,
  );
  Future<MyInfoModel?> getMyInfo() async {
    final response = await supabase
        .from(SupabaseConfig.tablePersonalInfo)
        .select();
    log(name: 'personal_info_response', response.toString());
    return MyInfoModel.fromJson(response[0]);
  }

  Future<SettingModel?> getSettings() async {
    final response = await supabase.from(SupabaseConfig.tableSetting).select();
    log(name: 'setting_response', response.toString());
    return SettingModel.fromJson(response[0]);
  }
}
