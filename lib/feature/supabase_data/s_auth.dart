import 'package:mivo/feature/supabase_data/s_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Admin sign-in for the mobile settings page.
///
/// The website never signs in: visitors only read public data. Everything
/// that changes data (deleting questions, editing settings) is allowed by the
/// backend only for a signed-in session of [SupabaseConfig.adminEmail].
class SupabaseAuth {
  SupabaseAuth._();
  static final SupabaseAuth instance = SupabaseAuth._();

  GoTrueClient get _auth => Supabase.instance.client.auth;

  /// True when a saved session belongs to the admin account.
  bool get isAdminSignedIn {
    final email = _auth.currentUser?.email?.toLowerCase();
    return email != null && email == SupabaseConfig.adminEmail;
  }

  /// Returns null on success, or an error message to show.
  Future<String?> signIn(String email, String password) async {
    final normalized = email.trim().toLowerCase();
    if (normalized != SupabaseConfig.adminEmail) {
      return 'This account is not allowed.';
    }
    try {
      await _auth.signInWithPassword(email: normalized, password: password);
      return isAdminSignedIn ? null : 'This account is not allowed.';
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not sign in. Check your connection and try again.';
    }
  }

  Future<void> signOut() => _auth.signOut();
}
