# Backend MLGC

Backend API untuk aplikasi MLGC (Machine Learning Google Cloud), yaitu layanan prediksi kanker kulit dari gambar. API ini menerima unggahan gambar, menjalankan inferensi memakai model TensorFlow, lalu menyimpan hasil prediksi ke Cloud Firestore sebagai riwayat.

## Fitur

- Prediksi klasifikasi gambar (Cancer / Non-cancer) beserta skor kepercayaan dan saran tindak lanjut
- Endpoint riwayat prediksi untuk melihat seluruh hasil prediksi yang tersimpan
- Batas ukuran payload gambar 1 MB dengan pesan error khusus untuk payload yang terlalu besar (HTTP 413)
- Penanganan error terpusat dengan format respons `status` dan `message`
- Siap dideploy sebagai container Docker (port 8080, cocok untuk Cloud Run)

## Teknologi

- Node.js 16
- Hapi (`@hapi/hapi`) sebagai framework server
- TensorFlow.js Node (`@tensorflow/tfjs-node`) untuk inferensi model
- Cloud Firestore (`@google-cloud/firestore`) sebagai basis data riwayat prediksi
- `dotenv` untuk konfigurasi lewat variabel lingkungan
- Nodemon untuk mode pengembangan

## Struktur Proyek

```
backend-mlgc/
├── config/            # Kredensial aplikasi dan skrip sintaks Cloud Run
├── models/            # Berkas model machine learning
├── src/
│   ├── exceptions/    # Kelas error khusus (InputError, ClientError)
│   ├── server/        # server.js, routes.js, handler.js
│   └── services/      # inferenceService, firestoreService, modelService
├── tests/             # Berkas pengujian
├── .env               # Konfigurasi lingkungan
├── Dockerfile
└── package.json
```

## Endpoint API

| Method | Path | Keterangan |
| ------ | ---- | ---------- |
| POST | `/predict` | Mengunggah gambar (multipart/form-data, field `image`) dan mendapatkan hasil prediksi |
| GET | `/predict/histories` | Mengambil seluruh riwayat prediksi dari Firestore |

Contoh respons sukses POST `/predict`:

```json
{
  "status": "success",
  "message": "Model is predicted successfully",
  "data": {
    "id": "<uuid>",
    "result": "Cancer",
    "suggestion": "Segera periksa ke dokter!",
    "confidenceScore": 99.12,
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

## Cara Menjalankan

Prasyarat: Node.js dan proyek Google Cloud dengan Firestore aktif.

1. Instal dependensi:

   ```bash
   npm install
   ```

2. Salin dan sesuaikan berkas `.env` (APP_ENV, APP_PORT, APP_HOST, MODEL_URL, LOCAL_MODEL_URL, PROJECT_ID). Untuk mode lokal, letakkan kredensial Google Cloud di `config/app_credentials.json` dan atur variabel `GOOGLE_APPLICATION_CREDENTIALS` bila diperlukan.

3. Jalankan server:

   ```bash
   npm start        # produksi
   npm run start:dev  # pengembangan (nodemon)
   ```

   Server berjalan di port 8080 secara bawaan.

### Menjalankan dengan Docker

```bash
docker build -t backend-mlgc .
docker run -p 8080:8080 backend-mlgc
```

## Repositori Terkait

- `mlgc-submission`, versi submission dari proyek MLGC yang sejenis.

## Lisensi

ISC (sesuai `package.json`).
