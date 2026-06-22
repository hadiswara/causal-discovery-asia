# Proyek Causal Discovery pada Dataset ASIA
Repositori ini berisi implementasi proyek analisis jaringan kausal menggunakan dataset ASIA (Lauritzen & Spiegelhalter, 1988) untuk mata kuliah **Pemodelan Kausal** di Magister Informatika, Universitas Islam Indonesia (UII).

---

## 📌 Gambaran Umum Proyek

Proyek ini bertujuan untuk menjawab pertanyaan kausal utama:  
> **"Apakah kebiasaan merokok (Smoking) secara kausal meningkatkan risiko kanker paru (Lung Cancer), dan bagaimana hubungannya dipengaruhi oleh variabel lain dalam sistem penyakit paru?"**

Repositori dibagi menjadi dua bagian utama untuk mencerminkan perkembangan analisis dari Pertemuan 8 ke Pertemuan 9:

### 1. Pertemuan 8 (P8) - Analisis Utama (PC Algorithm)
Pada tahap ini, dilakukan analisis dasar menggunakan **PC Algorithm** (*Constraint-based*):
*   **Data Preparation:** Pembersihan data biner kategorikal (5.000 observasi, 8 variabel) dan pemetaan ke representasi numerik.
*   **CI Test:** Menggunakan G-test (G-Square) melalui fungsi `disCItest` karena data bersifat diskrit kategorikal.
*   **Sensitivity Analysis:** Menjalankan algoritma PC dengan dua nilai signifikansi berbeda ($\alpha = 0.05$ dan $\alpha = 0.01$).
*   **Causal Inference:** Mengestimasi efek kausal (Average Causal Effect/ACE) dari Smoking ($S$) terhadap Lung Cancer ($L$) dengan Backdoor Adjustment.

### 2. Pertemuan 9 (P9) - Perbandingan Metode & Presentasi
Pada tahap ini, analisis diperluas dengan membandingkan tiga metode pencarian struktur serta menyiapkan bahan presentasi:
*   **PC Algorithm:** Menggunakan uji independensi kondisional (*constraint-based*).
*   **GES (Greedy Equivalence Search):** Metode *score-based* menggunakan pendekatan Gaussian (`GaussL0penObsScore`).
*   **Hill-Climbing (HC):** Metode *score-based* menggunakan skor BIC diskrit asli (`bic` di package `bnlearn`) sebagai perbandingan tipe data.
*   **Hasil Evaluasi:** Membandingkan performa ketiga metode tersebut dengan struktur asli (*True DAG*).
*   **Bahan Presentasi:** Penyusunan slide presentasi (.pptx) dan naskah presentasi per slide (.md) untuk diunggah ke Google NotebookLM.

---

## 📂 Struktur Repositori

*   **`Pertemuan 8/`**
    *   `analisis_asia.R` - Script R asli untuk analisis PC Algorithm dan estimasi ACE.
    *   `laporan_tugas_p8_asia.md` - Draft laporan analisis lengkap P8.
    *   `TUGAS 4 - KHAERUL HADISWARA ...` - Laporan final P8 dalam format Word (.docx) dan PDF.
    *   `bnlearn_data/` - Dataset pendukung R.
    *   `output/` - Visualisasi graf hasil PC Algorithm P8.
*   **`Pertemuan 9/`**
    *   `analisis_asia_p9.R` - Script R komparasi PC vs GES vs Hill-Climbing.
    *   `presentasi_p9.md` - Naskah berbicara per slide dan panduan tanya jawab (Q&A) untuk NotebookLM.
    *   `Causal Discovery Analysis PC vs. GES on ASIA Dataset.pptx` - File PowerPoint presentasi P9.
    *   `output/` - Grafik komparasi graf semua metode untuk bahan slide presentasi.

---

## 🚀 Cara Menjalankan Script R

Pastikan library `pcalg`, `bnlearn`, dan package Bioconductor `Rgraphviz` sudah terinstal di R Anda.

1.  **Untuk Menjalankan Analisis PC (P8):**
    ```R
    source("Pertemuan 8/analisis_asia.R")
    ```
2.  **Untuk Menjalankan Analisis Komparasi (P9):**
    ```R
    source("Pertemuan 9/analisis_asia_p9.R")
    ```
    *(Script P9 secara otomatis mendeteksi dan menginstal pustaka yang kurang jika Anda menjalankannya di Google Colab).*
