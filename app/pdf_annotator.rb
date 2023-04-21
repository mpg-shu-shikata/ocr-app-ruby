# frozen_string_literal: true

require 'dotenv'
require 'google/cloud/vision'
require 'base64'
require "google/cloud/storage"

Dotenv.load

class PdfAnnotator
  CREDENTIAL_FILE_PATH = './credentials.json'.freeze
  BUCKET_NAME = 'ocr-app-bucket-for-pdf'.freeze

  def self.call(base64_str)
    new(base64_str).call
  end

  def initialize(base64_str)
    @base64_str = base64_str
    @file_name = "#{SecureRandom.uuid}.pdf"
    @path = File.join('./', file_name)
  end

  def call
    google_storage_file = upload_pdf_to_google_storage
    response = annotate_file
    google_storage_file.delete
    extract_pdf_text(response.to_h)
  end

  private

  attr_reader :base64_str, :file_name, :path

  def upload_pdf_to_google_storage
    File.open(path, 'wb') do |f|
      f.puts Base64.decode64(base64_str)
      f.flush
    end

    file = google_storage_bucket.create_file(path, file_name)
    File.delete(path)
    file
  end

  def google_storage_bucket
    storage = Google::Cloud::Storage.new(
      credentials: CREDENTIAL_FILE_PATH
    )
    storage.bucket BUCKET_NAME
  end

  def client
    Google::Cloud::Vision.image_annotator do |config|
      config.credentials = ENV.fetch('CREDENTIALS_PATH')
    end
  end

  def build_params(uri)
    [
      {
        input_config: {
          mime_type: 'application/pdf',
          gcs_source: {
            uri: uri
          }
        },
        features: [
          {
            type: 'DOCUMENT_TEXT_DETECTION'
          }
        ]
      }
    ]
  end

  def annotate_file
    client.batch_annotate_files(requests: build_params("gs://#{BUCKET_NAME}/#{file_name}"))
  end

  def extract_pdf_text(google_vision_response)
    google_vision_response.dig(:responses, 0, :responses, 0, :full_text_annotation, :text)
  end
end
