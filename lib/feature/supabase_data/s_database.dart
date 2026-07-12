import 'dart:developer';

import 'package:mivo/core/model/ai_questions.dart';
import 'package:mivo/core/model/personal_info.dart';
import 'package:mivo/core/model/setting_model.dart';
import 'package:mivo/feature/supabase_data/s_config.dart';

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

  Future<List<QuestionModel>> getQuestions() async {
    final response = await supabase
        .from(SupabaseConfig.tableQuestions)
        .select()
        .order('created_at', ascending: false);

    return response
        .map<QuestionModel>((e) => QuestionModel.fromJson(e))
        .toList();
  }
}
