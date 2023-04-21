# frozen_string_literal: true

require 'functions_framework'
require 'google/cloud/logging'

require './app/image_annotator'
require './app/pdf_annotator'
require './app/text_completer'

FunctionsFramework.http 'image' do |request|
  params = JSON.parse(request.body.read.to_s, symbolize_names: true)

  logger.info '========================================'
  logger.info params
  logger.info '========================================'

  content = ImageAnnotator.call(params[:binaryData])
  TextCompleter.call(content)
end

FunctionsFramework.http 'pdf' do |request|
  params = JSON.parse(request.body.read.to_s, symbolize_names: true)

  logger.info '========================================'
  logger.info params
  logger.info '========================================'

  content = PdfAnnotator.call(params[:binaryData])
  TextCompleter.call(content)
end
