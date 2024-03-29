# frozen_string_literal: true

require 'base64'

require_relative './app/image_annotator'
require_relative './app/text_completer'

str = Base64.encode64(File.read('sample.png'))
content = ImageAnnotator.call(str)
TextCompleter.call(content)
