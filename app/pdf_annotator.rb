# frozen_string_literal: true

require 'dotenv'
require 'google/cloud/vision'
require 'base64'
require "google/cloud/storage"

Dotenv.load

class PdfAnnotator
  def self.call(base64_str)
    new(base64_str).call
  end

  def initialize(base64_str)
    @base64_str = base64_str
  end

  def call
    file_name = "#{SecureRandom.uuid}.pdf"
    path = File.join('./', file_name)

    # TODO: フロントとの繋ぎ込みが完了したら削除する
    # @base64_str = Base64.encode64(File.read('test.pdf'))
    # File.open(path, 'wb') do |f|
    #   f.puts Base64.decode64(base64_str)
    #   f.flush
    # end

    bucket = storage.bucket "ocr-app-bucket-for-pdf"
    bucket.create_file(path, file_name)

    response = client.batch_annotate_files(requests: build_params("gs://ocr-app-bucket-for-pdf/#{file_name}"))
    response.responses.first.responses.first.full_text_annotation.text
  end

  private

  attr_reader :base64_str

  def storage
    Google::Cloud::Storage.new(
      credentials: "./credentials.json"
    )
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
end
