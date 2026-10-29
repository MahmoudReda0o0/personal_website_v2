class SupabaseConfig {
  static const supabaseUrl = 'https://jwrafjkdzdffrznsnqmh.supabase.co';
  static const supabaseAnonKey =
      'sb_publishable_sU2nPl2cL4T0Epn3eocnZA_G_XohwGH';

  /// The only account allowed into the mobile settings page. Must match the
  /// email checked by the RLS policies (public.is_admin) and delete_question.
  static const adminEmail = 'mahmoudreda1321@gmail.com';

  static const tablePersonalInfo = 'personal_info';
  static const tableSocialMedia = 'social_media';
  static const tableSetting = 'settings';
  static const tableQuestions = 'aiquestions';
  static const tableSuggestedQuestions = 'suggested_questions';
}
