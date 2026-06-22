# ==========================================
# PROYEK CAUSAL DISCOVERY: DATASET ASIA
# ==========================================

# 1. PERSIAPAN LIBRARY
# Saya akan memuat library yang dibutuhkan untuk analisis ini.
# Saya sudah Pastikan library bnlearn, pcalg, BiocManager dan Rgraphviz sudah terinstall di komputer saya.
# install.packages("bnlearn")
# install.packages("pcalg")
# install.packages("BiocManager")
# BiocManager::install("Rgraphviz")
library(bnlearn)
library(pcalg)

# Saya membuat folder output untuk menyimpan semua gambar plot secara otomatis.
output_dir <- "./output"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# ==========================================
# PROSES 2: EKSPLORASI & PERSIAPAN DATA
# ==========================================
cat("\n===== PROSES 2: EKSPLORASI DATA =====\n")

# Saya memuat dataset 'asia' dari package bnlearn
data(asia)

# 2.1 Dimensi Data
# Saya melihat jumlah observasi dan variabel dalam dataset.
cat("Dimensi dataset (baris x kolom):", dim(asia), "\n")

# 2.2 Deskripsi Statistik
# Saya ingin melihat ringkasan distribusi setiap variabel.
cat("\nRingkasan Data:\n")
summary(asia)

# 2.3 Tabel Frekuensi Per Variabel
# Saya menampilkan distribusi frekuensi setiap variabel agar lebih detail.
cat("\nDistribusi Frekuensi Tiap Variabel:\n")
for (col in colnames(asia)) {
  cat("\n", col, ":\n")
  print(table(asia[[col]]))
}

# 2.4 Cek Missing Values
# Saya memastikan tidak ada nilai kosong (NA) pada dataset ini.
cat("\nJumlah Missing Value per variabel:\n")
print(colSums(is.na(asia)))
cat("Total Missing Value:", sum(is.na(asia)), "\n")
# Hasilnya 0, jadi saya tidak perlu melakukan imputasi data.

# 2.5 Cek Tipe Data
# Saya memverifikasi bahwa semua variabel bertipe 'Factor' dengan 2 level.
cat("\nStruktur Data:\n")
str(asia)

# Justifikasi CI Test saya:
# Karena seluruh data saya berupa variabel kategorikal diskrit (biner), saya 
# tidak bisa menggunakan korelasi linear biasa. Oleh karena itu, saya memilih 
# uji G-test (G-square) melalui fungsi disCItest pada package pcalg sebagai 
# Conditional Independence (CI) test yang sesuai untuk data diskrit.

# ==========================================
# PROSES 3: CAUSAL DISCOVERY (PC ALGORITHM)
# ==========================================
cat("\n===== PROSES 3: PC ALGORITHM =====\n")

# Package pcalg mensyaratkan input data kategorikal berupa numerik (dimulai dari 0).
# Jadi, saya mengkonversi setiap kolom factor menjadi integer (0 dan 1).
asia_numeric <- as.data.frame(lapply(asia, function(x) as.integer(x) - 1))
asia_numeric <- as.matrix(asia_numeric)

# Saya mendefinisikan jumlah level tiap variabel. Semuanya biner (2 level).
n_levels <- rep(2, ncol(asia))

# Saya menyiapkan parameter suffStat untuk fungsi pc()
suffStat <- list(dm = asia_numeric, nlev = n_levels, adaptDF = FALSE)

# Saya menjalankan algoritma PC. Sesuai panduan tugas, saya melakukan
# sensitivity analysis menggunakan dua nilai alpha yang berbeda.

# 3.1 Menjalankan PC Algorithm dengan Alpha = 0.05
# Saya menggunakan indepTest = disCItest karena data saya diskrit.
cat("\n--- PC Algorithm dengan Alpha = 0.05 ---\n")
pc_fit_05 <- pc(suffStat, indepTest = disCItest, alpha = 0.05,
                labels = colnames(asia), verbose = FALSE)
cat("Ringkasan CPDAG (alpha=0.05):\n")
summary(pc_fit_05)

# 3.2 Sensitivity Analysis: Menjalankan PC Algorithm dengan Alpha = 0.01
cat("\n--- PC Algorithm dengan Alpha = 0.01 ---\n")
pc_fit_01 <- pc(suffStat, indepTest = disCItest, alpha = 0.01,
                labels = colnames(asia), verbose = FALSE)
cat("Ringkasan CPDAG (alpha=0.01):\n")
summary(pc_fit_01)

# 3.3 Visualisasi Hasil
# Saya menge-plot kedua CPDAG dan menyimpannya sebagai file PNG.
png(file.path(output_dir, "cpdag_sensitivity_analysis.png"), width = 1200, height = 600, res = 150)
par(mfrow = c(1, 2))
plot(pc_fit_05, main = "CPDAG ASIA (Alpha = 0.05)")
plot(pc_fit_01, main = "CPDAG ASIA (Alpha = 0.01)")
par(mfrow = c(1, 1))
dev.off()
cat("Plot tersimpan: output/cpdag_sensitivity_analysis.png\n")

# 3.4 Sensitivity Analysis: Perbandingan jumlah edge
cat("\nPerbandingan Sensitivity Analysis:\n")
cat("Jumlah edge (alpha=0.05):", sum(as(pc_fit_05, "amat") != 0) / 2, "\n")
cat("Jumlah edge (alpha=0.01):", sum(as(pc_fit_01, "amat") != 0) / 2, "\n")
# Saya akan mendiskusikan perbedaan hasilnya di laporan.

# ==========================================
# PROSES 4: INTERPRETASI GRAF
# ==========================================
cat("\n===== PROSES 4: INTERPRETASI GRAF =====\n")

# 4.1 Menampilkan adjacency matrix dari CPDAG utama (alpha=0.05)
# Saya menggunakan hasil alpha=0.05 sebagai hasil utama.
cat("\nAdjacency Matrix CPDAG (alpha=0.05):\n")
amat_05 <- as(pc_fit_05, "amat")
print(amat_05)

# 4.2 Perbandingan dengan Struktur Asli (True DAG) Dataset ASIA
# Saya mendefinisikan struktur asli ASIA dari literatur Lauritzen & Spiegelhalter (1988).
cat("\n--- Perbandingan dengan Struktur Asli ---\n")
true_dag <- model2network("[A][S][T|A][L|S][B|S][D|B:E][E|T:L][X|E]")
cat("Struktur Asli ASIA (True DAG):\n")
print(arcs(true_dag))

# Saya menge-plot struktur asli sebagai pembanding dan menyimpannya sebagai PNG.
cat("\nPlot perbandingan Struktur Asli vs Hasil PC:\n")
png(file.path(output_dir, "perbandingan_true_dag_vs_pc.png"), width = 1200, height = 600, res = 150)
par(mfrow = c(1, 2))
graphviz.plot(true_dag, main = "True DAG ASIA")
plot(pc_fit_05, main = "CPDAG Hasil PC (Alpha=0.05)")
par(mfrow = c(1, 1))
dev.off()
cat("Plot tersimpan: output/perbandingan_true_dag_vs_pc.png\n")

# 4.3 Diskusi 3 Asumsi Utama
cat("\n--- Diskusi 3 Asumsi Utama ---\n")

cat("
1. CAUSAL MARKOV CONDITION:
   Asumsi ini mengasumsikan bahwa setiap variabel independen terhadap 
   non-descendants-nya jika dikondisikan pada parents-nya. Pada dataset ASIA,
   asumsi ini masuk akal karena dataset dirancang sebagai benchmark Bayesian 
   network dengan struktur kausal yang jelas.

2. FAITHFULNESS:
   Asumsi ini mengasumsikan tidak ada independensi 'kebetulan' yang muncul 
   akibat pembatalan efek (cancellation). Pada dataset ASIA, node E memiliki 
   conditional probability bernilai 0 dan 1 (deterministic OR), yang dapat 
   menyebabkan masalah faithfulness dan membuat beberapa edge gagal dipulihkan.

3. CAUSAL SUFFICIENCY:
   Asumsi ini mengasumsikan semua confounder penting sudah terobservasi. 
   Pada dataset ASIA yang sederhana ini, faktor laten seperti genetik, usia, 
   atau kualitas lingkungan tidak dimodelkan, sehingga asumsi ini bisa 
   dilanggar jika diterapkan pada data dunia nyata.
")

# ==========================================
# PROSES 5: ESTIMASI EFEK KAUSAL
# ==========================================
cat("\n===== PROSES 5: ESTIMASI EFEK KAUSAL =====\n")

# Berdasarkan pertanyaan penelitian saya, saya ingin mengestimasi efek kausal
# dari Smoking (S) terhadap Lung Cancer (L).

# 5.1 Asosiasi Observasional (tanpa adjustment)
# Saya menghitung tabel kontingensi untuk melihat korelasi observasionalnya.
cat("\n--- 5.1 Asosiasi Observasional ---\n")
tabel_SL <- table(asia$S, asia$L, dnn = c("Smoking", "LungCancer"))
cat("Tabel Kontingensi S (Smoking) vs L (Lung Cancer):\n")
print(tabel_SL)

cat("\nProbabilitas Kanker Paru berdasarkan status Merokok:\n")
print(prop.table(tabel_SL, margin = 1))

# Saya menghitung perbedaan risiko (risk difference) secara observasional.
prob_obs <- prop.table(tabel_SL, margin = 1)
risk_diff_obs <- prob_obs["yes", "yes"] - prob_obs["no", "yes"]
cat("\nRisk Difference Observasional P(L=yes|S=yes) - P(L=yes|S=no):", 
    round(risk_diff_obs, 4), "\n")

# 5.2 Backdoor Criterion
# Berdasarkan True DAG ASIA, hubungan S -> L adalah langsung tanpa confounder.
# Artinya TIDAK ada backdoor path dari S ke L, sehingga efek kausal BISA 
# diidentifikasi dan adjustment set-nya KOSONG (tidak perlu mengontrol variabel lain).
cat("\n--- 5.2 Backdoor Criterion ---\n")
cat("Pada True DAG: S -> L (hubungan langsung, tidak ada confounder)\n")
cat("Adjustment set: KOSONG (tidak ada variabel yang perlu dikontrol)\n")
cat("Artinya: P(L | do(S)) = P(L | S)\n")
cat("Efek kausal = asosiasi observasional karena tidak ada confounding.\n")

# 5.3 Estimasi Efek Kausal via Backdoor Adjustment (dengan bnlearn)
# Saya membangun Bayesian Network dari True DAG untuk mengestimasi efek kausal.
cat("\n--- 5.3 Estimasi Efek Kausal ---\n")

# Fit Bayesian Network pada struktur asli
bn_fit <- bn.fit(true_dag, asia)

# P(L=yes | do(S=yes)) - karena tidak ada confounder, sama dengan P(L=yes | S=yes)
# Saya menggunakan cpquery untuk mengestimasi probabilitas interventional.
set.seed(123)
p_lung_do_smoke <- cpquery(bn_fit, event = (L == "yes"), evidence = (S == "yes"), n = 100000)
p_lung_do_nosmoke <- cpquery(bn_fit, event = (L == "yes"), evidence = (S == "no"), n = 100000)

cat("P(L=yes | do(S=yes)) =", round(p_lung_do_smoke, 4), "\n")
cat("P(L=yes | do(S=no))  =", round(p_lung_do_nosmoke, 4), "\n")

# Average Causal Effect (ACE)
ace <- p_lung_do_smoke - p_lung_do_nosmoke
cat("\nAverage Causal Effect (ACE) = P(L|do(S=yes)) - P(L|do(S=no)) =", 
    round(ace, 4), "\n")

cat("\nInterpretasi: Nilai ACE positif menunjukkan bahwa intervensi merokok 
secara kausal meningkatkan risiko kanker paru sebesar", round(ace * 100, 2), 
"poin persentase.\n")

cat("\n===== ANALISIS SELESAI =====\n")
