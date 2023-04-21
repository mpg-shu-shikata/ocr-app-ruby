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

  params = JSON.parse(request.body.read.to_s, symbolize_names: true)

  logger.info '========================================'
  logger.info params
  logger.info '========================================'
  content = ImageAnnotator.call(params[:binaryData])

  logger.info content

  result = TextCompleter.call(content)

  logger.info result

  [200, headers, [result]]
end

FunctionsFramework.http 'pdf' do |request|
  headers = {
    'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => '*',
    'Access-Control-Allow-Headers' => '*',
    'Access-Control-Max-Age' => '3600'
  }
  params = JSON.parse(request.body.read.to_s, symbolize_names: true)
  content = PdfAnnotator.call(params[:binaryData])
  result = TextCompleter.call(content)

  [200, headers, [result]]
end
