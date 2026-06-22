# ==============================================================================
# PROYEK CAUSAL DISCOVERY & INFERENCE: DATASET ASIA (PC vs. GES)
# PERTEMUAN 9 - PEMODELAN KAUSAL
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. OTOMATISASI INSTALASI DEPENDENSI (Sangat berguna untuk Google Colab)
# ------------------------------------------------------------------------------
cat("=== 1. Memeriksa & Menginstal Library yang Dibutuhkan ===\n")

# Fungsi untuk menginstal package CRAN jika belum terinstal
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Menginstal package:", pkg, "\n"))
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
  }
}

# Memastikan BiocManager terinstal untuk dependensi Bioconductor
install_if_missing("BiocManager")

# Menginstal dependensi Bioconductor untuk pcalg dan visualisasi graph
bioc_pkgs <- c("graph", "RBGL", "Rgraphviz")
for (pkg in bioc_pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Menginstal Bioconductor package:", pkg, "\n"))
    BiocManager::install(pkg, update = FALSE, ask = FALSE)
  }
}

# Menginstal package CRAN utama
install_if_missing("bnlearn")
install_if_missing("pcalg")

# Memuat library
library(bnlearn)
library(pcalg)

# Mengatur folder output gambar secara dinamis (bekerja baik lokal maupun di Google Colab)
output_dir <- "./output"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# ------------------------------------------------------------------------------
# 2. EKSPLORASI & PERSIAPAN DATA
# ------------------------------------------------------------------------------
cat("\n=== 2. Eksplorasi & Persiapan Data ===\n")
data(asia)

cat("Dimensi dataset (baris x kolom):", dim(asia)[1], "x", dim(asia)[2], "\n")
cat("\nRingkasan dataset:\n")
print(summary(asia))

# Cek missing values
missing_count <- sum(is.na(asia))
cat("Total Missing Values:", missing_count, "\n")

# Justifikasi CI Test (G-Test):
# Karena data bersifat kategorikal diskrit biner, korelasi linier (Pearson) tidak tepat.
# Kita menggunakan G-test (G-Square) melalui 'disCItest' untuk uji independensi kondisional.

# Mengonversi data kategorikal (factor) ke integer (0 dan 1) untuk pcalg
asia_numeric <- as.data.frame(lapply(asia, function(x) as.integer(x) - 1))
asia_numeric <- as.matrix(asia_numeric)

# Jumlah level per variabel (semuanya biner = 2 level)
n_levels <- rep(2, ncol(asia))
suffStat <- list(dm = asia_numeric, nlev = n_levels, adaptDF = FALSE)

# ------------------------------------------------------------------------------
# 3. IMPLEMENTASI PC ALGORITHM & SENSITIVITY ANALYSIS
# ------------------------------------------------------------------------------
cat("\n=== 3. Menjalankan PC Algorithm (Sensitivity Analysis) ===\n")

# PC dengan alpha = 0.05
cat("\n--- PC Algorithm (Alpha = 0.05) ---\n")
pc_fit_05 <- pc(suffStat, indepTest = disCItest, alpha = 0.05,
                labels = colnames(asia), verbose = FALSE)
print(pc_fit_05)

# PC dengan alpha = 0.01
cat("\n--- PC Algorithm (Alpha = 0.01) ---\n")
pc_fit_01 <- pc(suffStat, indepTest = disCItest, alpha = 0.01,
                labels = colnames(asia), verbose = FALSE)
print(pc_fit_01)

# Visualisasi perbandingan sensitivitas PC
png(file.path(output_dir, "plot_pc_sensitivity.png"), width = 1200, height = 600, res = 150)
par(mfrow = c(1, 2))
plot(pc_fit_05, main = "PC Algorithm (Alpha = 0.05)")
plot(pc_fit_01, main = "PC Algorithm (Alpha = 0.01)")
par(mfrow = c(1, 1))
dev.off()
cat("Plot sensitivitas PC disimpan ke: output/plot_pc_sensitivity.png\n")

# ------------------------------------------------------------------------------
# 4. IMPLEMENTASI GES ALGORITHM (Score-based)
# ------------------------------------------------------------------------------
cat("\n=== 4. Menjalankan GES Algorithm ===\n")

# Justifikasi Fungsi Skor:
# GES pada pcalg mendefinisikan objek skor berbasis data kontinu (GaussL0penObsScore)
# yang merepresentasikan skor BIC ter-skala.
# Di sini kita menggunakannya pada representasi numerik (0/1) sebagai pendekatan kontinu.
score_obj <- new("GaussL0penObsScore", data = asia_numeric)
ges_fit <- ges(score_obj)

cat("Hasil GES (Representasi Adjacency Matrix):\n")
ges_amat <- as(ges_fit$essgraph, "matrix")
print(ges_amat)

# Visualisasi hasil GES
png(file.path(output_dir, "plot_ges_result.png"), width = 600, height = 600, res = 150)
plot(ges_fit$essgraph, main = "GES Algorithm (BIC Gauss Approximation)")
dev.off()
cat("Plot GES disimpan ke: output/plot_ges_result.png\n")

# ------------------------------------------------------------------------------
# 5. IMPLEMENTASI HILL-CLIMBING DISCRETE (Sebagai Alternatif/Pembanding Tipe Data)
# ------------------------------------------------------------------------------
cat("\n=== 5. Menjalankan Hill-Climbing (Discrete BIC) ===\n")

# Justifikasi:
# Karena dataset ASIA sepenuhnya kategorikal diskrit, algoritma score-based diskrit
# seperti Hill-Climbing dengan skor BIC diskrit ('bic') memberikan estimasi yang
# secara statistik lebih valid dibanding pendekatan Gaussian pada GES.
hc_fit <- hc(asia, score = "bic")
print(hc_fit)

# Visualisasi hasil HC
png(file.path(output_dir, "plot_hc_discrete.png"), width = 600, height = 600, res = 150)
graphviz.plot(hc_fit, main = "Hill-Climbing (Discrete BIC)")
dev.off()
cat("Plot Hill-Climbing disimpan ke: output/plot_hc_discrete.png\n")

# ------------------------------------------------------------------------------
# 6. PERBANDINGAN STRUKTUR DENGAN STRUKTUR ASLI (TRUE DAG)
# ------------------------------------------------------------------------------
cat("\n=== 6. Perbandingan Struktur vs. True DAG ===\n")

# Definisikan True DAG ASIA dari literatur
true_dag <- model2network("[A][S][T|A][L|S][B|S][D|B:E][E|T:L][X|E]")

# Menghitung metrik perbandingan (Jumlah Edge & Kualitas Arah)
cat("Jumlah Edge pada True DAG:", nrow(arcs(true_dag)), "\n")
cat("Jumlah Edge pada PC (alpha=0.05):", sum(as(pc_fit_05, "amat") != 0) / 2, "\n")
cat("Jumlah Edge pada GES (Gaussian):", sum(ges_amat != 0) / 2, "\n")
cat("Jumlah Edge pada HC (Discrete):", nrow(arcs(hc_fit)), "\n")

# Visualisasi Perbandingan Semua Metode
png(file.path(output_dir, "perbandingan_semua_metode.png"), width = 1200, height = 1200, res = 150)
par(mfrow = c(2, 2))

# Plot True DAG
graphviz.plot(true_dag, main = "1. True DAG (Lauritzen & Spiegelhalter)")
# Plot PC
plot(pc_fit_05, main = "2. PC Algorithm (Alpha=0.05)")
# Plot GES
plot(ges_fit$essgraph, main = "3. GES (Gauss-BIC Approximation)")
# Plot HC
graphviz.plot(hc_fit, main = "4. Hill-Climbing (Discrete BIC)")

par(mfrow = c(1, 1))
dev.off()
cat("Plot perbandingan 4 metode disimpan ke: output/perbandingan_semua_metode.png\n")

# ------------------------------------------------------------------------------
# 7. CAUSAL INFERENCE & ESTIMASI EFEK KAUSAL
# ------------------------------------------------------------------------------
cat("\n=== 7. Causal Inference (Backdoor Adjustment) ===\n")
cat("Pertanyaan Kausal: Efek merokok (S) terhadap Kanker Paru (L)\n")

# Asosiasi Observasional
tabel_SL <- table(asia$S, asia$L, dnn = c("Smoking", "LungCancer"))
prob_obs <- prop.table(tabel_SL, margin = 1)
cat("\nProbabilitas Observasional P(L = yes | S):\n")
print(prob_obs)

risk_diff_obs <- prob_obs["yes", "yes"] - prob_obs["no", "yes"]
cat("Risk Difference Observasional P(L=yes|S=yes) - P(L=yes|S=no):", round(risk_diff_obs, 4), "\n")

# Analisis Backdoor:
# Pada True DAG ASIA, hubungan S -> L adalah hubungan langsung.
# Tidak ada panah masuk ke S (Smoking tidak memiliki parent), sehingga tidak ada backdoor path.
# Maka, Adjustment Set (Z) adalah KOSONG.
# Secara teori: P(L | do(S)) = P(L | S) (tidak ada confounding bias).

# Estimasi Numerik via Simulasi Intervensi (MCMC) pada Model Terbaik (bnlearn)
bn_fit <- bn.fit(true_dag, asia)

set.seed(123)
p_lung_do_smoke <- cpquery(bn_fit, event = (L == "yes"), evidence = (S == "yes"), n = 100000)
p_lung_do_nosmoke <- cpquery(bn_fit, event = (L == "yes"), evidence = (S == "no"), n = 100000)

cat("\nProbabilitas Intervensional Hasil Estimasi:\n")
cat("P(L = yes | do(S = yes)) =", round(p_lung_do_smoke, 4), "\n")
cat("P(L = yes | do(S = no))  =", round(p_lung_do_nosmoke, 4), "\n")

# Average Causal Effect (ACE)
ace <- p_lung_do_smoke - p_lung_do_nosmoke
cat("\nAverage Causal Effect (ACE):", round(ace, 4), "\n")
cat("Interpretasi: Intervensi merokok meningkatkan risiko kanker paru secara kausal sebesar", 
    round(ace * 100, 2), "% di populasi.\n")

cat("\n=== SELURUH ANALISIS P9 SELESAI ===\n")
