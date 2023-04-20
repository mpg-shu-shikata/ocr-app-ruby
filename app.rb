# frozen_string_literal: true

require 'functions_framework'
require 'google/cloud/logging'

FunctionsFramework.http 'image' do |request|
  ImageAnnotator.call('base64_string')
end

FunctionsFramework.http 'pdf' do |request|
  # TODO: クラスを呼び出す
end
