# Google Cloud Pubsub
Output events and detections to a Pubsub topic.

* `secret_key`: the secret json key identifying a service account.
* `project`: the GCP Project name where the Topic lives.
* `topic`: use this specific value as a topic.

Example:
```yaml
project: my-project
topic: telemetry
secret_key: {
  "type": "service_account",
  "project_id": "my-lc-data",
  "private_key_id": "11b6f4173dedabcdefb779e4afae6d88ddce3cc1",
  "private_key": "-----BEGIN PRIVATE KEY-----\n.....\n-----END PRIVATE KEY-----\n",
  "client_email": "my-service-writer@my-lc-data.iam.gserviceaccount.com",
  "client_id": "102526666608388828174",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-service-writer%40my-lc-data.iam.gserviceaccount.com"
}
```