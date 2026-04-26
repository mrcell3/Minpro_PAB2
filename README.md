# KostKu 🏠

Aplikasi mobile manajemen penghuni kost berbasis Flutter dengan integrasi Supabase dan autentikasi pengguna. Dirancang untuk membantu pemilik kost dalam mengelola data penghuni secara mudah dan efisien.

---

## Deskripsi Aplikasi

KostKu adalah aplikasi sederhana namun fungsional untuk membantu pemilik kost dalam mencatat dan mengelola data penghuni kost secara digital. Data tersimpan di cloud menggunakan Supabase sehingga dapat diakses kapan saja. Pengguna harus login terlebih dahulu sebelum dapat mengelola data penghuni miliknya.

---

## Fitur Aplikasi

| Fitur | Keterangan |
|---|---|
| 🔐 Register | Membuat akun baru menggunakan email dan password |
| 🔑 Login | Masuk ke akun yang sudah terdaftar via Supabase Auth |
| 🚪 Logout | Keluar dari akun dengan konfirmasi dialog |
| ➕ Tambah Penghuni | Menambahkan data penghuni baru ke Supabase |
| 📋 Lihat Daftar | Menampilkan semua penghuni dari database Supabase |
| 🔍 Detail Penghuni | Melihat informasi lengkap satu penghuni |
| ✏️ Edit Penghuni | Mengubah data penghuni yang tersimpan di Supabase |
| 🗑️ Hapus Penghuni | Menghapus data penghuni dari Supabase dengan konfirmasi dialog |
| 🌙 Dark / Light Mode | Toggle tampilan gelap dan terang |
| ✅ Validasi Input | Nama hanya huruf, HP diawali 08, format kamar A1/B2, harga min Rp 100.000 |
| 📅 Date Picker | Tanggal masuk menggunakan kalender picker |

---

## Struktur Folder

```
minpro_pab2/
├── .env
├── pubspec.yaml
├── Tampilan_aplikasi
└── lib/
    ├── main.dart
    ├── models/
    │   └── penghuni.dart
    ├── services/
    │   └── supabase_service.dart
    ├── pages/
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   ├── home_page.dart
    │   ├── add_edit_page.dart
    │   └── detail_page.dart
    └── widgets/
        └── penghuni_card.dart
```

---

## Widget yang Digunakan

| Widget | Kegunaan |
|---|---|
| `MaterialApp` | Root aplikasi dengan konfigurasi tema global light & dark |
| `Scaffold` | Struktur dasar setiap halaman |
| `CustomScrollView` + `SliverAppBar` | Header expandable di Home & Detail |
| `FlexibleSpaceBar` | Konten dalam SliverAppBar |
| `SliverList` + `SliverFillRemaining` | List penghuni dan tampilan kosong |
| `RefreshIndicator` | Pull to refresh data dari Supabase |
| `GestureDetector` | Mendeteksi tap pada card penghuni |
| `Container` | Styling custom box dengan dekorasi |
| `LinearGradient` | Background gradient warna navy |
| `BoxShadow` | Efek bayangan pada card |
| `Form` + `GlobalKey<FormState>` | Form dengan validasi |
| `TextFormField` | Input field dengan validator |
| `FilteringTextInputFormatter` | Membatasi input sesuai aturan tiap field |
| `showDatePicker` | Kalender picker untuk tanggal masuk |
| `ElevatedButton` + `OutlinedButton` | Tombol aksi simpan, edit, dan hapus |
| `FloatingActionButton.extended` | Tombol tambah penghuni di Home |
| `AlertDialog` | Dialog konfirmasi hapus dan logout |
| `CircularProgressIndicator` | Loading indicator saat fetch/simpan data |
| `Navigator` + `MaterialPageRoute` | Navigasi antar halaman (multi-page) |

---

## Tampilan Aplikasi📲

<table>
  <tr>
    <th>Login</th>
    <th>Register</th>
  </tr>  
  <tr>
    <td><img width="387" height="664" alt="login" src="https://github.com/user-attachments/assets/cce51011-8b70-4a08-9b96-e272e7fde5af" /></td>
    <td><img width="384" height="732" alt="register" src="https://github.com/user-attachments/assets/f6791ae5-fc6d-4e21-abff-a3e005cedd07" /></td>
  </tr>
  <tr>
    <th>Tambah Penghuni</th>
    <th>Lihat Daftar Penghuni</th>
  </tr>  
  <tr>
    <td><img width="385" height="778" alt="create" src="https://github.com/user-attachments/assets/de34bb37-55af-4185-81d7-ab2539278a2d" /></td>
    <td><img width="385" height="812" alt="home" src="https://github.com/user-attachments/assets/fddc7b02-bb39-4529-a327-161121f85766" /></td>
  </tr>
  <tr>
    <th>Detail Penghuni</th>
    <th>Edit Data Penghuni</th>
  </tr>  
  <tr>
    <td><img width="384" height="756" alt="detail" src="https://github.com/user-attachments/assets/9f389be0-da80-4538-a076-73e9320a6b3a" /></td>
    <td><img width="384" height="773" alt="update" src="https://github.com/user-attachments/assets/62aa286d-ed0b-41ea-befb-6e9aae20e35f" /></td>
  </tr>
  <tr>
    <th>Tanggal masuk menggunakan Date Picker</th>
    <th>Dark Mode</th>
  </tr>  
  <tr>
    <td><img width="384" height="810" alt="date picker" src="https://github.com/user-attachments/assets/999fb0a2-8c54-43b8-a7b7-be8d4b9bb81d" /></td>
    <td><img width="376" height="803" alt="home - dark mode" src="https://github.com/user-attachments/assets/1c77996c-c785-4abe-bf9f-971c35c66325" /></td>
  </tr>
</table>
