import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/penghuni.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  static Future<AuthResponse> register(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await _client.auth.signOut();
  }

  static User? get currentUser => _client.auth.currentUser;

  static Future<List<Penghuni>> fetchPenghuni() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('penghuni')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Penghuni.fromJson(e)).toList();
  }

  static Future<Penghuni> tambahPenghuni(Penghuni penghuni) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('User tidak ditemukan');

    final data = penghuni.toJson();
    data['user_id'] = userId;

    final response = await _client
        .from('penghuni')
        .insert(data)
        .select()
        .single();

    return Penghuni.fromJson(response);
  }

  static Future<Penghuni> updatePenghuni(Penghuni penghuni) async {
    final response = await _client
        .from('penghuni')
        .update(penghuni.toJson())
        .eq('id', penghuni.id)
        .select()
        .single();

    return Penghuni.fromJson(response);
  }

  static Future<void> hapusPenghuni(String id) async {
    await _client.from('penghuni').delete().eq('id', id);
  }
}