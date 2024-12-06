gcloud builds submit --tag gcr.io/[PROJECT ID]/[PROJECT DIRECTORY]

gcloud run deploy backend-mlgc \
--image gcr.io/[PROJECT ID]/[PROJECT DIRECTORY] \
--set-env-vars APP_ENV=production,APP_PORT=8080,APP_HOST=0.0.0.0,MODEL_URL=[MODEL URL] \
--platform managed \
--region asia-southeast2 \
--allow-unauthenticated
