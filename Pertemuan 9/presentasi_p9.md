# PANDUAN & NASKAH PRESENTASI PERTEMUAN 9
## Proyek Causal Discovery: Dataset ASIA (PC vs. GES)
**Nama:** Khaerul Hadiswara  
**NIM:** 25917025  
**Mata Kuliah:** Pemodelan Kausal  
**Program Studi:** Magister Informatika, Universitas Islam Indonesia (UII)  

---

## DAFTAR SLIDE & NASKAH BICARA (SPEECH SCRIPT)

### SLIDE 1: Judul Presentasi
*   **Konten Slide:**
    *   **Judul:** Analisis Perbandingan Causal Discovery (PC Algorithm vs. GES) pada Dataset ASIA
    *   **Subjudul:** Tugas Pertemuan 9 - Pemodelan Kausal
    *   **Nama:** Khaerul Hadiswara (NIM: 25917025)
    *   **Instansi:** Magister Informatika, Universitas Islam Indonesia
    *   **Sumber Dataset:** Dataset ASIA (Lauritzen & Spiegelhalter, 1988)
*   **Naskah Bicara (Speech Script) — Estimasi Durasi: 45 detik**
    > "Selamat pagi/siang Bapak Dosen dan rekan-rekan mahasiswa. Perkenalkan, nama saya Khaerul Hadiswara dengan NIM 25917025. Pada kesempatan kali ini, saya akan mempresentasikan hasil proyek Causal Discovery saya yang membandingkan metode Constraint-based (PC Algorithm) dan Score-based (GES) pada dataset ASIA. Dataset ini merupakan dataset benchmark klasik dalam pemodelan probabilistik dan jaringan kausal yang pertama kali diperkenalkan oleh Lauritzen dan Spiegelhalter pada tahun 1988."

---

### SLIDE 2: Latar Belakang Masalah
*   **Konten Slide:**
    *   **Kenapa Causal Discovery?:** Hubungan asosiatif/korelasi tidak cukup untuk menggambarkan mekanisme penyakit paru yang sebenarnya.
    *   **Studi Kasus:** Mengapa seseorang mengalami sesak napas (dyspnoea)? Apakah karena merokok, kanker paru, bronkitis, atau kombinasi di antaranya?
    *   **Pentingnya Intervensi:** Memahami struktur kausal membantu kita memprediksi dampak intervensi (seperti larangan merokok) secara tepat melalui estimasi efek kausal ($P(\text{Outcome} \mid do(\text{Treatment}))$, bukan sekadar probabilitas kondisional biasa ($P(\text{Outcome} \mid \text{Treatment})$).
*   **Naskah Bicara (Speech Script) — Estimasi Durasi: 1 menit**
    > "Latar belakang dari proyek ini adalah kenyataan bahwa dalam dunia medis, hubungan korelasi saja tidak cukup untuk mengambil keputusan klinis atau kebijakan kesehatan. Misalnya, kita tahu merokok berasosiasi dengan sesak napas, tetapi bagaimana mekanismenya? Apakah merokok langsung menyebabkan sesak napas, atau melalui perantara penyakit lain seperti bronkitis atau kanker paru? Dengan causal discovery, kita mencoba mengungkap struktur sebab-akibat (DAG) dari data observasional tanpa harus melakukan eksperimen acak terkontrol (RCT) yang mahal atau bahkan tidak etis."

---

### SLIDE 3: Pertanyaan Kausal & Deskripsi Dataset
*   **Konten Slide:**
    *   **Pertanyaan Kausal Utama:** *"Apakah kebiasaan merokok (S) secara kausal meningkatkan risiko kanker paru (L), dan bagaimana hubungannya dijembatani oleh variabel lain dalam sistem penyakit paru?"*
    *   **Deskripsi Dataset:**
        *   Jumlah Observasi: 5.000 data observasional.
        *   Jumlah Variabel: 8 variabel kategorikal biner (Faktor dengan tingkat *yes* / *no*).
    *   **Tabel Variabel:**
        *   `A` (Visit to Asia), `T` (Tuberculosis), `S` (Smoking), `L` (Lung Cancer), `B` (Bronchitis), `E` (Tuberculosis or Lung Cancer), `X` (X-ray), `D` (Dyspnoea).
    *   **Data Quality:** 0% missing data, tidak ada outliers karena seluruh data bersifat kategorikal diskrit.
*   **Naskah Bicara (Speech Script) — Estimasi Durasi: 1 menit**
    > "Pertanyaan kausal utama yang ingin saya jawab adalah: Apakah kebiasaan merokok (S) secara kausal meningkatkan risiko kanker paru (L), dan bagaimana struktur hubungannya dalam sistem penyakit paru? Dataset yang saya gunakan memiliki 5.000 baris observasi dan 8 variabel kategorikal biner. Seluruh variabel bernilai 'yes' atau 'no'. Kualitas data sangat baik karena tidak memiliki missing value atau data kosong, sehingga tidak diperlukan imputasi data."

---

### SLIDE 4: Metodologi & Parameter Analisis
*   **Konten Slide:**
    *   **1. Penyiapan Data:** Mengonversi data kategorikal menjadi representasi numerik (0/1) khusus untuk kebutuhan algoritma tertentu di `pcalg`.
    *   **2. PC Algorithm (Constraint-based):**
        *   Uji Independensi Kondisional (CI Test): **G-test ($G^2$ / G-Square)** via fungsi `disCItest` karena data diskrit.
        *   Sensitivity Analysis: Dijalankan pada dua nilai $\alpha$ berbeda: $0.05$ dan $0.01$.
    *   **3. GES Algorithm (Score-based):**
        *   Fungsi Skor: **BIC (Bayesian Information Criterion)** via `GaussL0penObsScore` dengan parameter penalti default $\lambda = \log(N)/2$.
    *   **4. Hill-Climbing (Discrete Score-based):**
        *   Sebagai pembanding tambahan, dijalankan algoritma HC dari package `bnlearn` menggunakan skor BIC khusus discrete (`bic`).
*   **Naskah Bicara (Speech Script) — Estimasi Durasi: 1 menit 15 detik**
    > "Untuk metodologinya, saya melakukan perbandingan antara PC Algorithm dan GES. Pada PC Algorithm, karena data kita kategorikal, saya menggunakan uji G-test (G-Square) sebagai uji independensi kondisional. Saya juga melakukan analisis sensitivitas dengan ambang batas alpha 0.05 dan 0.01. Untuk GES dari package pcalg, saya menggunakan skor BIC yang diaproksimasi dengan GaussL0penObsScore. Sebagai pembanding tambahan yang lebih sesuai dengan karakteristik data diskrit, saya juga menjalankan algoritma Hill-Climbing dari package bnlearn dengan skor BIC diskrit asli untuk melihat perbedaannya."

---

### SLIDE 5: Hasil Visualisasi Graf (PC vs. GES vs. HC vs. True DAG)
*   **Konten Slide:**
    *   **True DAG (Lauritzen & Spiegelhalter, 1988):** Memiliki 8 edge berarah.
    *   **Hasil PC (Alpha = 0.05 & 0.01):** Menghasilkan graf yang identik (robust). Menemukan 4 edge (3 tidak berarah: `S-L`, `S-B`, `B-D`, dan 1 v-structure berarah: `L -> E <- T`).
    *   **Hasil GES (pcalg):** Menemukan graf dengan 6 edge, namun ada beberapa edge berarah terbalik (misal `E -> L` dan `E -> T`) akibat pendekatan Gaussian pada data diskrit.
    *   **Hasil Hill-Climbing (bnlearn):** Berhasil memulihkan 7 dari 8 edge dengan arah yang sangat akurat, membuktikan bahwa penanganan data secara diskrit menghasilkan akurasi yang jauh lebih tinggi.
*   **Naskah Bicara (Speech Script) — Estimasi Durasi: 1 menit 30 detik**
    > "Di slide ini, kita bisa melihat hasil grafnya. True DAG di sebelah kiri memiliki 8 edge berarah. Hasil algoritma PC dengan alpha 0.05 dan 0.01 menghasilkan struktur yang sama persis, yang berarti hasilnya sangat robust. PC berhasil mengidentifikasi v-structure penting L ke E dan T ke E. Namun, edge lain seperti S-L dan S-B terdeteksi tanpa arah. Menariknya, GES dengan pendekatan Gaussian menghasilkan beberapa edge yang terbalik arahnya karena data dipaksakan dianggap kontinu. Sementara itu, algoritma Hill-Climbing berbasis skor diskrit di bnlearn menghasilkan graf yang hampir sempurna—berhasil menemukan 7 dari 8 edge dengan arah yang benar, hanya kehilangan hubungan Asia ke Tuberkulosis."

---

### SLIDE 6: Estimasi Efek Kausal & Asumsi
*   **Konten Slide:**
    *   **Target Efek:** Efek kausal merokok ($S$) terhadap kanker paru ($L$): $P(L \mid do(S))$.
    *   **Backdoor Criterion:** Berdasarkan graf, tidak ada *backdoor path* dari $S$ ke $L$. Oleh karena itu, *Adjustment Set* $Z = \emptyset$ (kosong).
    *   **Estimasi Kausal:** $P(L \mid do(S)) = P(L \mid S)$
        *   $P(L = \text{yes} \mid do(S = \text{yes})) = 11.75\%$
        *   $P(L = \text{yes} \mid do(S = \text{no})) = 1.38\%$
        *   **Average Causal Effect (ACE):** $0.1175 - 0.0138 = 0.1037$ (Kausal meningkatkan risiko kanker paru sebesar **10.4%**).
    *   **Evaluasi 3 Asumsi Utama:**
        *   *Causal Markov Condition:* Terpenuhi karena data dihasilkan secara sintetis dari Bayesian network.
        *   *Faithfulness:* **Terlanggar** pada variabel $E$ karena hubungan deterministik OR ($E = T \lor L$), menyebabkan hilangnya edge dari $E$ ke $X$ dan $D$.
        *   *Causal Sufficiency:* Terpenuhi secara desain (tidak ada confounder laten tersembunyi).
*   **Naskah Bicara (Speech Script) — Estimasi Durasi: 1 menit 30 detik**
    > "Selanjutnya, saya menghitung efek kausal merokok terhadap kanker paru. Berdasarkan graf asli dan hasil discovery, tidak ada jalur backdoor dari Smoking ke Lung Cancer. Ini berarti efek kausalnya teridentifikasi secara langsung tanpa perlu melakukan kontrol atau adjustment pada variabel lain. Hasil estimasi menunjukkan probabilitas kanker paru jika diintervensi merokok adalah 11,75%, sedangkan jika diintervensi tidak merokok adalah 1,38%. Nilai Average Causal Effect atau ACE-nya adalah 10,4%, menunjukkan merokok secara kausal meningkatkan risiko kanker paru sebesar 10,4% di populasi ini. Terkait asumsi, asumsi Markov dan Sufficiency terpenuhi dengan baik. Namun, asumsi Faithfulness terlanggar pada node E karena fungsi logika deterministik OR (Tuberculosis OR Lung Cancer), yang menyebabkan algoritma PC gagal mendeteksi hubungan E ke X-ray dan E ke sesak napas."

---

### SLIDE 7: Kesimpulan & Bahan Diskusi
*   **Konten Slide:**
    *   **Kesimpulan Utama:**
        1.  PC Algorithm sangat robust (sensitivitas stabil), berhasil mendeteksi v-structure tetapi banyak edge yang tidak berarah.
        2.  Penanganan tipe data sangat krusial; metode diskrit (Hill-Climbing) jauh mengungguli GES yang memakai pendekatan Gaussian pada data kategorikal biner ini.
        3.  Hubungan deterministik (seperti variabel E) melanggar asumsi *Faithfulness*, yang menjadi tantangan besar bagi algoritma berbasis constraint.
    *   **Bahan Diskusi Kelas:**
        *   Bagaimana mendeteksi hubungan deterministik dalam data riil sebelum melakukan causal discovery?
        *   Bagaimana mengatasi keterbatasan sampel kecil (seperti data kunjungan Asia yang hanya 42 kejadian) pada performa algoritma?
*   **Naskah Bicara (Speech Script) — Estimasi Durasi: 1 menit**
    > "Sebagai kesimpulan, proyek ini memperlihatkan bahwa algoritma PC sangat robust terhadap perubahan alpha, namun memiliki kelemahan dalam mengorientasikan edge tanpa bantuan v-structure. Kedua, kita melihat betapa pentingnya kesesuaian tipe data; memaksakan data diskrit ke dalam algoritma kontinu (GES) menghasilkan arah edge yang keliru, sedangkan algoritma diskrit (HC) memberikan hasil yang sangat akurat. Terakhir, hubungan logika deterministik seperti pada variabel E terbukti merusak asumsi Faithfulness dan menghilangkan edge penting. Pertanyaan menarik yang ingin saya diskusikan adalah bagaimana kita bisa secara otomatis mendeteksi hubungan deterministik seperti ini pada data dunia nyata sebelum menjalankan algoritma. Terima kasih, saya persilakan jika ada masukan dari Bapak Dosen dan rekan-rekan sekalian."

---

## PANDUAN ANTISIPASI PERTANYAAN DOSEN / TANYA JAWAB (Q&A PREPARATION)

### Pertanyaan 1: "Mengapa pada hasil PC Algorithm, edge S ke L dan S ke B tidak memiliki arah (tidak berarah)?"
*   **Jawaban Kunci:**
    > "Algoritma PC menentukan arah panah berdasarkan deteksi v-structure (collider) dan aturan orientasi Meek. Pada variabel $S$ (Smoking), $L$ (Lung Cancer), dan $B$ (Bronchitis), tidak terbentuk v-structure yang mengarah ke variabel-variabel tersebut dari pasangan independen. Karena tidak ada informasi collider di sekitar $S$, $L$, dan $B$, algoritma PC tidak memiliki informasi statistik yang cukup untuk membedakan arah $S \rightarrow L$ dari $L \rightarrow S$ berdasarkan data observasional saja, sehingga membiarkannya tidak berarah (undirected edge)."

### Pertanyaan 2: "Mengapa edge A -> T (Visit to Asia ke Tuberculosis) hilang pada hasil PC dan HC?"
*   **Jawaban Kunci:**
    > "Hal ini disebabkan oleh masalah **kekuatan uji statistik (statistical power)** akibat ketidakseimbangan data yang ekstrem (data sparsity). Dari 5.000 observasi, hanya ada 42 orang yang memiliki riwayat perjalanan ke Asia (`A = yes`). Karena jumlah sampel positif sangat sedikit, uji independensi kondisional G-test tidak memiliki kekuatan yang cukup untuk menolak hipotesis nol independensi, sehingga algoritma menyimpulkan $A \perp T$ dan menghapus edge tersebut."

### Pertanyaan 3: "Mengapa asumsi Faithfulness terlanggar pada node E? Apa dampak matematisnya?"
*   **Jawaban Kunci:**
    > "Variabel $E$ didefinisikan secara deterministik sebagai logika OR: $E = T \lor L$. Ketika sebuah hubungan bersifat deterministik, probabilitas kondisional bernilai ekstrem (0 atau 1). Secara matematis, ini menciptakan independensi kondisional yang 'kebetulan' yang tidak direpresentasikan oleh pemisahan graf biasa (d-separation). Akibatnya, algoritma PC melihat $E$ independen dengan $X$ dan $D$ pada kondisi tertentu, sehingga menghapus edge $E \rightarrow X$ dan $E \rightarrow D$. Pelanggaran Faithfulness ini menunjukkan bahwa hubungan deterministik murni adalah batasan utama dari algoritma constraint-based standar."

### Pertanyaan 4: "Mengapa hasil GES (pcalg) kurang bagus dibandingkan Hill-Climbing (bnlearn)?"
*   **Jawaban Kunci:**
    > "Sebab implementasi `ges()` pada package `pcalg` dirancang untuk data kontinu dan menggunakan scoring Gaussian (`GaussL0penObsScore`). Ketika kita memaksa data diskrit (0 dan 1) ke dalam model Gaussian, asumsi distribusi normal dilanggar secara ekstrem. Hal ini membuat perhitungan skor likelihood tidak akurat dan mengacaukan orientasi arah panah. Sebaliknya, Hill-Climbing di `bnlearn` dikonfigurasi dengan skor `bic` diskrit yang menghitung multinomial likelihood secara tepat, sehingga menghasilkan struktur yang jauh lebih mendekati True DAG."
