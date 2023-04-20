# frozen_string_literal: true

require 'functions_framework'
require 'google/cloud/logging'

require './app/image_annotator'
require './app/text_completer'

FunctionsFramework.http 'image' do |request|
  logger.info '========================================'
  logger.info request.body
  logger.info '========================================'
  content = ImageAnnotator.call('base64_string')
  TextCompleter.call(content)
end

FunctionsFramework.http 'pdf' do |request|
  # TODO: クラスを呼び出す
end
