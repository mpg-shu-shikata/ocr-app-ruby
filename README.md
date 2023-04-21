## ocr-app-ruby
Ruby 3.2.1

## GCP
- Google Cloud Function
- Google Cloud Storage
- Google Form
- Google App Script
- Google Cloud Logging

## 外部API
- Google Cloud Vision API
- Google Drive API
- OpenAI API

## GCFのデプロイコマンド
gcloud CLIを使用してます（[install](https://cloud.google.com/sdk/docs/install?hl=ja)）

pdf:
```zsh
gcloud functions deploy pdf --runtime ruby32 --trigger-http --allow-unauthenticated
```

image:
```zsh
gcloud functions deploy image --runtime ruby32 --trigger-http --allow-unauthenticated
```
