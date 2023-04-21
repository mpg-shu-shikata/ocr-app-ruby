# frozen_string_literal: true

require 'dotenv'
require 'google/cloud/vision'

Dotenv.load

require_relative './http_client'

VISION_API_URL = 'https://vision.googleapis.com/v1'

class ImageAnnotator
  def self.call(base64_str)
    new(base64_str).call
  end

  def initialize(base64_str)
    @base64_str = base64_str
  end

  def call
    url = File.join(VISION_API_URL, "/images:annotate?key=#{ENV.fetch('CLOUD_VISION_API_KEY')}")
    response = HttpClient.post(url, params)
    response.dig('responses', 0, 'textAnnotations', 0, 'description') || ''
  end

  private

  attr_reader :base64_str

  def params
    {
      requests: [
        {
          image: {
            content: base64_str
          },
          features: [
            { type: 'DOCUMENT_TEXT_DETECTION' }
          ]
        }
      ]
    }
  end
end
