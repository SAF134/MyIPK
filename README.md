# MyIPK 🎓

MyIPK adalah aplikasi manajemen akademik komprehensif yang dirancang khusus untuk membantu mahasiswa melacak jadwal kuliah, meninjau Indeks Prestasi Kumulatif (IPK) dan Indeks Prestasi Semester (IPS), serta mengelola tugas perkuliahan secara efisien dalam satu dasbor yang rapi dan premium.

## ✨ Fitur Utama

- **📊 Kalkulator IPK & IPS Akurat**: 
  Lacak nilai dari setiap mata kuliah berdasarkan bobot SKS. Aplikasi akan mengkalkulasi IPS tiap semester dan IPK keseluruhan secara otomatis menggunakan indeks nilai standar (A, AB, B, BC, C, D, E).
- **📅 Manajemen Jadwal Kuliah**:
  Simpan jadwal kuliah harian Anda lengkap dengan ruangan dan waktu.
- **📝 Pengelola Tugas (Task Manager)**:
  Catat tugas kuliah beserta tenggat waktunya. Halaman depan akan menampilkan 3 tugas paling mendesak.
- **🔔 Sistem Pengingat Cerdas (Push Notifications)**:
  Aplikasi akan secara otomatis mengirimkan notifikasi:
  - **15 menit** sebelum kelas dimulai (rutin setiap minggu).
  - **24 jam** sebelum tenggat waktu tugas.
- **👆 Interaksi Gestur Modern (Swipe-to-Dismiss)**:
  Geser kartu mata kuliah, jadwal, atau tugas ke kiri untuk menghapus atau ke kanan untuk mengedit dengan animasi yang halus.
- **🪄 Animasi Lottie (Empty States)**:
  Tampilan kosong yang interaktif dan menyenangkan berkat integrasi Lottie ketika Anda belum memiliki data.
- **🗄️ Penyimpanan Lokal Super Cepat (Hive)**:
  Semua data jadwal, tugas, dan nilai disimpan secara permanen, aman, dan sangat cepat di perangkat Anda menggunakan NoSQL Hive Database (tanpa membutuhkan koneksi internet).

## 🛠️ Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan framework **Flutter** dengan beberapa dependensi utama:
- `hive` & `hive_flutter`: Operasi database lokal (CRUD) berkinerja tinggi.
- `flutter_local_notifications` & `timezone`: Sistem penjadwalan alarm dan notifikasi presisi tinggi.
- `flutter_slidable`: Interaksi gestur *swipe* pada elemen daftar.
- `lottie`: Render animasi vektor untuk UI yang lebih hidup.

## 🚀 Cara Menjalankan Aplikasi

1. **Kloning repositori ini**
   ```bash
   git clone https://github.com/SAF134/MyIPK.git
   ```
2. **Masuk ke direktori proyek**
   ```bash
   cd MyIPK
   ```
3. **Instal semua dependensi**
   ```bash
   flutter pub get
   ```
4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## 📸 Tangkapan Layar (Screenshots)
*(Tambahkan gambar tangkapan layar antarmuka aplikasi di sini untuk mempercantik README Anda nantinya)*

---
Dibuat dengan ❤️ untuk produktivitas mahasiswa.
