# frozen_string_literal: true

require 'functions_framework'
require 'google/cloud/logging'

require_relative './image_annotator'
require_relative './text_completer'

FunctionsFramework.http 'image' do |request|
  content = ImageAnnotator.call('base64_string')
  TextCompleter.call(content)
end

FunctionsFramework.http 'pdf' do |request|
  # TODO: クラスを呼び出す
end
