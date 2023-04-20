# frozen_string_literal: true

require 'functions_framework'
require 'google/cloud/logging'

require './app/image_annotator'
require './app/text_completer'

FunctionsFramework.http 'image' do |request|
  headers = {
    'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => '*',
    'Access-Control-Allow-Headers' => '*',
    'Access-Control-Max-Age' => '3600'
  }
  return [204, headers, []] if request.request_method == 'OPTIONS'

  # CORS preflight request

  # Handle actual request
  return [200, headers, ['Hello, World!']]

  logger.info '========================================'
  logger.info request.body
  logger.info '========================================'
  # content = ImageAnnotator.call('base64_string')
  # TextCompleter.call(content)
end

FunctionsFramework.http 'pdf' do |request|
  # TODO: クラスを呼び出す
end
