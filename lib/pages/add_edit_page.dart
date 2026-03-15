import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/penghuni.dart';

class AddEditPage extends StatefulWidget {
  final Penghuni? penghuni;

  const AddEditPage({super.key, this.penghuni});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _nomorKamarController;
  late final TextEditingController _nomorHPController;
  late final TextEditingController _tanggalMasukController;
  late final TextEditingController _hargaSewaController;

  DateTime? _selectedDate;

  bool get _isEdit => widget.penghuni != null;

  @override
  void initState() {
    super.initState();
    _namaController =
        TextEditingController(text: widget.penghuni?.nama ?? '');
    _nomorKamarController =
        TextEditingController(text: widget.penghuni?.nomorKamar ?? '');
    _nomorHPController =
        TextEditingController(text: widget.penghuni?.nomorHP ?? '');
    _hargaSewaController =
        TextEditingController(text: widget.penghuni?.hargaSewa ?? '');

    if (widget.penghuni?.tanggalMasuk != null &&
        widget.penghuni!.tanggalMasuk.isNotEmpty) {
      try {
        final parts = widget.penghuni!.tanggalMasuk.split('/');
        if (parts.length == 3) {
          _selectedDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }
    _tanggalMasukController = TextEditingController(
      text:
          _selectedDate != null ? _formatTanggal(_selectedDate!) : '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nomorKamarController.dispose();
    _nomorHPController.dispose();
    _tanggalMasukController.dispose();
    _hargaSewaController.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF162447),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalMasukController.text = _formatTanggal(picked);
      });
    }
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final result = Penghuni(
        id: widget.penghuni?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        nama: _namaController.text.trim(),
        nomorKamar: _nomorKamarController.text.trim(),
        nomorHP: _nomorHPController.text.trim(),
        tanggalMasuk: _tanggalMasukController.text.trim(),
        hargaSewa: _hargaSewaController.text.trim(),
      );
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white70 : const Color(0xFF162447);
    final labelColor = isDark ? Colors.white70 : const Color(0xFF555555);
    final sectionColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final cardColor =
        isDark ? const Color(0xFF1C2333) : Colors.white;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEdit ? 'Edit Penghuni' : 'Tambah Penghuni',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF162447), Color(0xFF0D1B35)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.person_add_outlined,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEdit
                            ? 'Edit Data Penghuni'
                            : 'Data Penghuni Baru',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Lengkapi semua field di bawah ini',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(16),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Informasi Personal', sectionColor: sectionColor, barColor: iconColor),
                    const SizedBox(height: 12),

                    _buildField(
                      iconColor: iconColor,
                      labelColor: labelColor,
                      label: 'Nama Lengkap',
                      controller: _namaController,
                      icon: Icons.person_outline,
                      hint: 'Masukkan nama penghuni',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        if (v.trim().length < 3) {
                          return 'Nama minimal 3 karakter';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v.trim())) {
                          return 'Nama hanya boleh berisi huruf';
                        }
                        return null;
                      },
                    ),

                    _buildField(
                      iconColor: iconColor,
                      labelColor: labelColor,
                      label: 'Nomor HP',
                      controller: _nomorHPController,
                      icon: Icons.phone_outlined,
                      hint: 'Contoh: 08123456789',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nomor HP tidak boleh kosong';
                        }
                        if (!v.startsWith('08')) {
                          return 'Nomor HP harus diawali 08';
                        }
                        if (v.length < 10) {
                          return 'Nomor HP minimal 10 digit';
                        }
                        if (v.length > 13) {
                          return 'Nomor HP maksimal 13 digit';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),
                    _sectionTitle('Informasi Kamar', sectionColor: sectionColor, barColor: iconColor),
                    const SizedBox(height: 12),

                    _buildField(
                      iconColor: iconColor,
                      labelColor: labelColor,
                      label: 'Nomor Kamar',
                      controller: _nomorKamarController,
                      icon: Icons.door_back_door_outlined,
                      hint: 'Contoh: A1, B2',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                        LengthLimitingTextInputFormatter(5),
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nomor kamar tidak boleh kosong';
                        }
                        if (!RegExp(r'^[A-Za-z][0-9]{1,2}$')
                            .hasMatch(v.trim())) {
                          return 'Format kamar tidak valid (contoh: A1, B12)';
                        }
                        return null;
                      },
                    ),

                    _buildDateField(iconColor: iconColor, labelColor: labelColor),

                    _buildField(
                      iconColor: iconColor,
                      labelColor: labelColor,
                      label: 'Harga Sewa per Bulan (Rp)',
                      controller: _hargaSewaController,
                      icon: Icons.payments_outlined,
                      hint: 'Contoh: 1500000',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Harga sewa tidak boleh kosong';
                        }
                        final angka = int.tryParse(v.trim());
                        if (angka == null) {
                          return 'Harga sewa harus berupa angka';
                        }
                        if (angka < 100000) {
                          return 'Harga sewa minimal Rp 100.000';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _simpan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF162447),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _isEdit
                              ? 'Simpan Perubahan'
                              : 'Tambah Penghuni',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({required Color iconColor, required Color labelColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanggal Masuk',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _tanggalMasukController,
            readOnly: true,
            onTap: _pilihTanggal,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Tanggal masuk tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Pilih tanggal masuk',
              hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
              prefixIcon: Icon(Icons.calendar_today_outlined,
                  color: iconColor, size: 20),
              suffixIcon: _selectedDate != null
                  ? IconButton(
                      icon: const Icon(Icons.close,
                          size: 18, color: Color(0xFF888888)),
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                          _tanggalMasukController.clear();
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {required Color sectionColor, required Color barColor}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: sectionColor,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required Color iconColor,
    required Color labelColor,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
              prefixIcon: Icon(icon, color: iconColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}