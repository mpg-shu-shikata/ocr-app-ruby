# frozen_string_literal: true

require 'dotenv'
require 'google/cloud/vision'

Dotenv.load

class ImageAnnotator
  def self.call(base64_str)
    new(base64_str).call
  end

  def initialize(base64_str)
    @base64_str = base64_str
  end

  def call
    response = client.batch_annotate_images(requests:)
    response.to_h.dig(:responses, 0, :full_text_annotation, :text)
  end

  private

  attr_reader :base64_str

  def client
    Google::Cloud::Vision.image_annotator do |config|
      config.credentials = ENV.fetch('CREDENTIALS_PATH')
    end
  end

  def requests
    [
      {
        image: {
          content: base64_str
        },
        features: [
          { type: 'DOCUMENT_TEXT_DETECTION' }
        ]
      }
    ]
  end
end
