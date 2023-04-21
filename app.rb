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

  content = ImageAnnotator.call(params[:data])
  TextCompleter.call(content).tap { |tc| logger.info(tc) }
end

FunctionsFramework.http 'pdf' do |request|
  params = JSON.parse(request.body.read.to_s, symbolize_names: true)

  logger.info '========================================'
  logger.info params
  logger.info '========================================'

  content = PdfAnnotator.call(params[:data])
  TextCompleter.call(content).tap { |tc| logger.info(tc) }
end
