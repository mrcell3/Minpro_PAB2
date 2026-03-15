import 'package:flutter/material.dart';
import '../models/penghuni.dart';
import '../services/supabase_service.dart';
import 'add_edit_page.dart';

class DetailPage extends StatefulWidget {
  final Penghuni penghuni;
  final VoidCallback onHapus;
  final Function(Penghuni) onUpdated;

  const DetailPage({
    super.key,
    required this.penghuni,
    required this.onHapus,
    required this.onUpdated,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Penghuni _penghuni;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _penghuni = widget.penghuni;
  }

  Future<void> _navigasiEdit() async {
    final result = await Navigator.push<Penghuni>(
      context,
      MaterialPageRoute(
          builder: (_) => AddEditPage(penghuni: _penghuni)),
    );
    if (result != null) {
      setState(() => _isLoading = true);
      try {
        final updated = await SupabaseService.updatePenghuni(result);
        setState(() => _penghuni = updated);
        widget.onUpdated(updated);
      } catch (e) {
        if (mounted) _showError('Gagal menyimpan perubahan: $e');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _konfirmasiHapus() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Penghuni',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
          'Yakin ingin menghapus data ${_penghuni.nama}? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      setState(() => _isLoading = true);
      try {
        await SupabaseService.hapusPenghuni(_penghuni.id);
        widget.onHapus();
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) _showError('Gagal menghapus data: $e');
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C2333) : Colors.white;
    final bgColor =
        isDark ? const Color(0xFF0D1117) : const Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: const Color(0xFF162447),
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: _isLoading ? null : _navigasiEdit,
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _isLoading ? null : _konfirmasiHapus,
                    tooltip: 'Hapus',
                  ),
                  const SizedBox(width: 4),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2),
                            ),
                            child: Center(
                              child: Text(
                                _penghuni.nomorKamar,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _penghuni.nama,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Kamar ${_penghuni.nomorKamar}',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF162447),
                              Color(0xFF0D1B35)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text('Harga Sewa per Bulan',
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${_penghuni.hargaSewa}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Informasi Penghuni',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 16),
                            _infoRow(Icons.phone_outlined, 'Nomor HP',
                                _penghuni.nomorHP, isDark: isDark),
                            _infoRow(
                                Icons.calendar_today_outlined,
                                'Tanggal Masuk',
                                _penghuni.tanggalMasuk, isDark: isDark),
                            _infoRow(
                                Icons.door_back_door_outlined,
                                'Nomor Kamar',
                                _penghuni.nomorKamar,
                                isLast: true, isDark: isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : _konfirmasiHapus,
                              icon: const Icon(Icons.delete_outline,
                                  size: 18),
                              label: const Text('Hapus'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(
                                    color: Colors.red),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isLoading ? null : _navigasiEdit,
                              icon: const Icon(Icons.edit_outlined,
                                  size: 18),
                              label: const Text('Edit Data'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF162447),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {bool isLast = false, bool isDark = false}) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFF162447).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: isDark ? Colors.white70 : const Color(0xFF162447),
                  size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF888888))),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
      ],
    );
  }
}