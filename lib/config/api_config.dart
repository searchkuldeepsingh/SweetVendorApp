class ApiConfig {
  static const supabaseUrl = 'https://fzzwzgbjadngaivfpdxt.supabase.co';
  static const supabaseAnonKey =
      'sb_publishable_Cljcmt4PfjJ0XgwHM_K0UQ_HOOeF6iU';

  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
