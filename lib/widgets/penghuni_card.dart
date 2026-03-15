import 'package:flutter/material.dart';
import '../models/penghuni.dart';

class PenghuniCard extends StatelessWidget {
  final Penghuni penghuni;
  final VoidCallback onTap;

  const PenghuniCard({
    super.key,
    required this.penghuni,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C2333) : Colors.white;
    final iconColor = isDark ? Colors.white70 : const Color(0xFF162447);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF162447), Color(0xFF0D1B35)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    penghuni.nomorKamar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      penghuni.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: Color(0xFF888888),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          penghuni.nomorHP,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.15) : const Color(0xFF162447).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Rp ${_formatHarga(penghuni.hargaSewa)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatHarga(String harga) {
    final angka = int.tryParse(harga);
    if (angka == null) return harga;
    if (angka >= 1000000) {
      return '${(angka / 1000000).toStringAsFixed(1)}jt';
    }
    if (angka >= 1000) {
      return '${(angka / 1000).toStringAsFixed(0)}rb';
    }
    return harga;
  }
}