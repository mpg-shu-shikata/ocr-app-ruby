# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

class HttpClient
  def initialize(url, params)
    @url = url
    @uri = URI.parse(url)
    @params = params
  end

  def self.post(url, params)
    new(url, params).post
  end

  def post
    response = net_http.request(net_http_post, params.to_json)
    JSON.parse(response.body)
  end

  private

  attr_reader :url, :uri, :params

  def net_http
    Net::HTTP.new(uri.host, uri.port).tap { |http| http.use_ssl = https? }
  end

  def https?
    url.start_with?('https')
  end

  def net_http_post
    Net::HTTP::Post.new(uri.request_uri).tap do |net_http_post|
      net_http_post['Content-Type'] = 'application/json'
    end
  end
end
