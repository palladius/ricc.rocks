# 📸 Ricc Pixel Tracker on Cloud Run

A zero-cost, ultra-lightweight tracking pixel service designed for **Cloud Run** and **Google Cloud Logging**.

## 🚀 Highlights
- **Zero Cost**: Easily fits into the Cloud Run free tier (2 million requests/month free).
- **Zero Cookies**: 100% GDPR-friendly. No cookie banner required.
- **Works in RSS feeds & Markdown**: Since it is a 1x1 transparent GIF image (`/pixel.gif`), it tracks page views even when users have JavaScript disabled or read via RSS.
- **Structured JSON Logging**: Writes structured JSON directly to stdout; Cloud Run feeds it to **Google Cloud Logging** automatically.

---

## 🛠️ Deploy to Cloud Run (1 Command)

```bash
cd services/pixel-tracker

# Deploy from source using Google Cloud Buildpacks (or Dockerfile)
gcloud run deploy ricc-pixel-tracker \
  --source . \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 128Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10
```

Cloud Run will output your service URL, for example:
`https://ricc-pixel-tracker-xyz-ew.a.run.app`

---

## 🔗 How to use in `ricc.rocks` (Hugo)

Add your service URL to `zzo.ricc.rocks/config/_default/params.yaml`:

```yaml
pixelAnalyticsUrl: 'https://ricc-pixel-tracker-xyz-ew.a.run.app/pixel.gif'
```

Hugo automatically injects the pixel into the page body on production builds:
```html
<img src="https://ricc-pixel-tracker-xyz-ew.a.run.app/pixel.gif?p=/en/posts/my-post/" width="1" height="1" style="display:none;" alt="" loading="eager" />
```

---

## 📊 Viewing Metrics in Cloud Logging & BigQuery

### 1. View logs in real-time
```bash
gcloud beta run services logs tail ricc-pixel-tracker --region europe-west1
```

Or in Cloud Logging Logs Explorer:
```sql
resource.type="cloud_run_revision"
resource.labels.service_name="ricc-pixel-tracker"
jsonPayload.event="pageview"
```

### 2. Stream into BigQuery (Free Log Router Sink)
To analyze top pages, referral sources, and countries in SQL:
```bash
gcloud logging sinks create pixel_pageviews_bq \
  bigquery.googleapis.com/projects/YOUR_PROJECT_ID/datasets/analytics \
  --log-filter='resource.type="cloud_run_revision" AND resource.labels.service_name="ricc-pixel-tracker" AND jsonPayload.event="pageview"'
```
