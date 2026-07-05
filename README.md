# Analisis Tren Penjualan E-Commerce dan Performa Produk (SQL Portofolio)

## 1. Konteks dan Masalah
* Konteks: Perusahaan mengelola data transaksi e-commerce yang mencakup informasi detail produk, performa penjualan, karakteristik pelanggan, serta waktu transaksi.
* Problem Statement: Manajemen membutuhkan sebuah validasi data yang bersih untuk melihat tren pendapatan bersih bulanan, memantau aktivitas transaksi terbaru secara *real-time*, serta mengidentifikasi produk-produk unggulan yang menghasilkan performa di atas rata-rata sebagai dasar pengambilan keputusan stok dan promosi.

## 2. Struktur Dataset & Langkah Pembersihan Data
Proyek ini menggunakan tabel tunggal 'ecomm' yang menyimpat seluruh riwayat transaksi. Untuk memastikan standardisasi sebelum dianalisis, langkah manipulasi dan pembersihan data berikut dilakukan menggunakan fungsi SQL:
* Standardisasi Teks: Mengubah lokasi pelanggan menjadi huruf kapital menggunakan 'UPPER(customerlocation)' dan merapikan penulisan kategori menggunakan REPLACE(category, '&', 'and').
* Pembuatan kode produk unik: Membuat format kode baru dengan menggabungkan 3 huruf pertama nama produk dan 2 digit terakhir ID produk melalui fungsi 'CONCAT(SUBSTRING(productname, 1, 3), '-', RIGHT(productid::varchar, 2))'.
* Kalkukasi pendapatan bersih: Menghitung pendapatan riil setelah potongan harga dengan rumus finansial.

## 3. Proses Analisi & Metodologi (Pendekatan Query)
Analisis data dijalankan secara terstruktur melalui beberapa pendekatan query SQL:
* Analisis tren finansial bulanan: Mengelompokkan data berdasarkan waktu menggunakan 'DATE_TRUNC('month', purchasedate)' serta fungsi 'EXTRACT' untuk memvalidasi total transaksi dan akumulasi 'net revenue' secara kronologis.
* Monitoring transaki terkini: Menggunakan filter dinamis 'INTERVAL '7 day'' dari tanggal maksimum transaksi di database bersama fungsi waktu sistem ('NOW()', 'CURRENT_TIMESTAMP') untuk memantau produk yang terjual dalam seminggu terakhir.
* Analisis performa produk: Menggunakan teknik 'Common Table Expression' (WITH clause) dan 'Subquery' untuk menyaring daftar produk yang memiliki harga maupun kontribusi 'net_revenue' di atas rata-rata industri.
* Volume penjualan terbanyak: Melakukan agregasi 'SUM(quantitysold)' dengan pengelompokan nama produk untuk memetakan produk terlaris secara kuantitas.

## 4. Temuan Utama (Insights)
* Tren pendapatan bulanan: Proses tracking berkala menunjukkan fluktuasi 'net revenue' dari bulan ke bulan, di mana efektivitas promosi dan besaran persentase diskon berdampak langsung pada volume transaksi yang tercipta.
* Segmentasi produk premium: Berdasarkan filter subquery rata-rata, berhasil dipetakan varian produk yang masuk dalam kategori 'high-value', serta produk yang menghasilkan profit bersih di atas rata-rata performa toko.
* Pergerakan investaris cepat: Produk dengan volume penjualan tertinggi mendominasi perputaran stok bulanan, memberikan sinyal prioritas bagi tim logistik untuk menjaga kestabilan pasokan.

## 5. Rekomendasi yang didapatkan untuk dieksekusi
* Strategi penetapan harga dan diskon: Pendapatan bersih sangat dipengaruhi oleh variable diskon, lebih baik promo dibatasi terutama diskon besar untuk produk dengan margin yang tinggi atau produk yang berada dibawah rata-rata performa penjualan.
* Menentukan pasokan barang berdasarkan performa penjualan: Membagi alokasi modal dan ruang investaris lebih besar pada produk-produk yang teridentifikasi oleh CTE memiliki 'net revenue' diatas rata-rata untuk memaksimalkan profitabilitas.
* Automasi dashboard laporan terkini: Memanfaatkan struktur query '7 hari terakhir' sebagai basic visualisasi data 'real-time' untuk tim operasional untuk memantau lonjakan permintaan secara instan.
