# MyIPK 🎓

MyIPK adalah aplikasi manajemen akademik komprehensif yang dirancang khusus untuk membantu mahasiswa melacak jadwal kuliah, meninjau Indeks Prestasi Kumulatif (IPK) dan Indeks Prestasi Semester (IPS), serta mengelola tugas perkuliahan secara efisien dalam satu dasbor yang elegan, cepat, dan interaktif.

## ✨ Fitur Utama

- **📊 Kalkulator IPK & Statistik Akademik**: 
  Lacak nilai dari setiap mata kuliah berdasarkan bobot SKS. Aplikasi akan mengkalkulasi IPS tiap semester dan IPK keseluruhan secara otomatis. Dilengkapi dengan **Grafik Interaktif** (Tren IPS *Line Chart* dan Sebaran Nilai *Pie Chart*) untuk memvisualisasikan progres belajar Anda dari waktu ke waktu.
- **📅 Manajemen Jadwal Kuliah**:
  Simpan jadwal kuliah harian Anda lengkap dengan ruangan dan waktu. Ditampilkan dalam bentuk kartu jadwal yang rapi.
- **📝 Pengelola Tugas (Task Manager) & Kalender**:
  Catat tugas kuliah beserta tenggat waktunya. Dilengkapi dengan kalender bulanan interaktif; Anda dapat menekan tanggal tertentu untuk melihat daftar tugas di hari tersebut.
- **🔔 Sistem Pengingat Cerdas (Push Notifications)**:
  Aplikasi akan secara otomatis mengirimkan notifikasi:
  - **15 menit** sebelum kelas dimulai (rutin setiap minggu).
  - **24 jam** sebelum tenggat waktu tugas.
- **👆 Interaksi Gestur Modern (Swipe-to-Dismiss)**:
  Geser kartu mata kuliah, jadwal, atau tugas ke kiri untuk menghapus atau ke kanan untuk mengedit dengan animasi yang halus tanpa perlu berpindah halaman.
- **⚡ Performa Ekstrem & Native Splash Screen**:
  Dioptimalkan dengan arsitektur *True Lazy Loading (SliverList)* untuk konsumsi memori yang sangat rendah meski memiliki ribuan daftar. Aplikasi juga terbuka seketika (*instant launch*) berkat implementasi *Native Splash Screen*.
- **🗄️ Penyimpanan Lokal Super Cepat (Hive)**:
  Semua data jadwal, tugas, dan nilai disimpan secara permanen, aman, dan sangat cepat langsung di perangkat Anda (tanpa membutuhkan koneksi internet atau *cloud server*).

## 🛠️ Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan framework **Flutter** dengan beberapa dependensi andalan:
- `hive` & `hive_flutter`: Operasi database lokal (NoSQL) berkinerja sangat tinggi.
- `fl_chart`: Render visualisasi data statistik akademik yang memukau.
- `table_calendar`: Penampil kalender tugas bulanan yang interaktif.
- `flutter_local_notifications` & `timezone`: Sistem penjadwalan alarm dan notifikasi presisi tinggi yang berjalan di latar belakang.
- `flutter_slidable`: Interaksi gestur *swipe* pada elemen daftar.
- `flutter_native_splash`: *Branding* aplikasi profesional saat *booting*.
- `lottie`: Render animasi vektor untuk UI (seperti halaman kosong) yang lebih hidup.

## 🚀 Cara Menjalankan Aplikasi

1. **Pastikan Anda telah menginstal Flutter SDK** versi 3.10 ke atas.
2. **Kloning repositori ini**
   ```bash
   git clone https://github.com/SAF134/MyIPK.git
   ```
3. **Masuk ke direktori proyek**
   ```bash
   cd MyIPK
   ```
4. **Instal semua dependensi**
   ```bash
   flutter pub get
   ```
5. **(Opsional) Bangun ulang Splash Screen** jika Anda mengubah logo:
   ```bash
   flutter pub run flutter_native_splash:create
   ```
6. **Jalankan aplikasi** ke emulator atau perangkat fisik Anda:
   ```bash
   flutter run
   ```

## 📸 Tangkapan Layar (Screenshots)
*(Tambahkan gambar tangkapan layar antarmuka aplikasi di sini untuk mempercantik profil GitHub Anda nantinya)*

---
**Dibuat dengan ❤️ untuk produktivitas mahasiswa.**
