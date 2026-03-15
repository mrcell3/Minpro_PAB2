import 'package:flutter/material.dart';
import '../models/penghuni.dart';
import '../services/supabase_service.dart';
import '../widgets/penghuni_card.dart';
import '../main.dart';
import 'add_edit_page.dart';
import 'detail_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Penghuni> _daftarPenghuni = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final data = await SupabaseService.fetchPenghuni();
      if (mounted) setState(() => _daftarPenghuni = data);
    } catch (e) {
      if (mounted) _showError('Gagal memuat data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _navigasiTambah() async {
    final result = await Navigator.push<Penghuni>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditPage()),
    );
    if (result != null) {
      try {
        final saved = await SupabaseService.tambahPenghuni(result);
        setState(() => _daftarPenghuni.insert(0, saved));
      } catch (e) {
        if (mounted) _showError('Gagal menambah data: $e');
      }
    }
  }

  void _hapusPenghuni(String id) {
    setState(() => _daftarPenghuni.removeWhere((p) => p.id == id));
  }

  void _updatePenghuni(Penghuni updated) {
    setState(() {
      final index = _daftarPenghuni.indexWhere((p) => p.id == updated.id);
      if (index != -1) _daftarPenghuni[index] = updated;
    });
  }

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF162447),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      await SupabaseService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = MyApp.of(context);
    final bgColor =
        isDark ? const Color(0xFF0D1117) : const Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: _fetchData,
        color: const Color(0xFF162447),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              backgroundColor: const Color(0xFF162447),
              actions: [
                IconButton(
                  icon: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => appState?.toggleTheme(),
                  tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: _logout,
                  tooltip: 'Keluar',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF162447), Color(0xFF0D1B35)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KostKu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_daftarPenghuni.length} Penghuni Terdaftar',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _statCard(
                                'Total Kamar',
                                '${_daftarPenghuni.map((p) => p.nomorKamar).toSet().length}',
                                Icons.door_back_door_outlined,
                              ),
                              const SizedBox(width: 12),
                              _statCard(
                                'Terisi',
                                '${_daftarPenghuni.length}',
                                Icons.people_outline,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Penghuni',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${_daftarPenghuni.length} orang',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFF162447)),
                ),
              )
            else if (_daftarPenghuni.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF162447).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.people_outline,
                            size: 40, color: Color(0xFF162447)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum ada penghuni',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tambah penghuni dengan tombol + di bawah',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final penghuni = _daftarPenghuni[index];
                    return PenghuniCard(
                      penghuni: penghuni,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(
                              penghuni: penghuni,
                              onHapus: () =>
                                  _hapusPenghuni(penghuni.id),
                              onUpdated: _updatePenghuni,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: _daftarPenghuni.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigasiTambah,
        backgroundColor: const Color(0xFF162447),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Penghuni',
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(label,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}