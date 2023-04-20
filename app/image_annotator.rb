# frozen_string_literal: true

require 'dotenv'
require 'google/cloud/vision'
require 'base64'

Dotenv.load

class ImageAnnotator
  def self.call(base64_str)
    new(base64_str).call
  end

  def initialize(base64_str)
    # @base64_str = base64_str
    @base64_str = File.binread('test.jpg')
  end

  def call
    client = Google::Cloud::Vision.image_annotator do |config|
      config.credentials = ENV.fetch('CREDENTIALS_PATH')
    end

    response = client.batch_annotate_images(requests:)
    response.to_h.dig(:responses, 0, :full_text_annotation, :text)
  end

  private

  attr_reader :base64_str

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
