## ocr-app-ruby
Ruby Version 3.2.1

## GCP
- Cloud Function
- Cloud Storage
- Google Form
- GAS

## 外部API
- Cloud Vision API
- OpenAI API

## GCFのデプロイコマンド
pdf
```zsh
gcloud functions deploy pdf --runtime ruby32 --trigger-http --allow-unauthenticated
```

image
```zsh
gcloud functions deploy image --runtime ruby32 --trigger-http --allow-unauthenticated
```
