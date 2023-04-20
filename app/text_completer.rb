# frozen_string_literal: true

require 'dotenv'
require 'openai'

Dotenv.load

class TextCompleter
  def self.call(content)
    new(content).call
  end

  def initialize(content)
    @content = content
  end

  def call
    return if content.nil? || content.empty?

    client = OpenAI::Client.new(access_token: ENV.fetch('OPENAI_API_KEY'))
    response = client.chat(parameters:)
    JSON.parse(response.dig('choices', 0, 'message', 'content'), symbolize_names: true)
  end

  private

  attr_reader :content

  def parameters
    {
      model: 'gpt-3.5-turbo',
      temperature: 0,
      max_tokens: 1024,
      messages: [
        { role: 'system', content: system_content },
        { role: 'user', content: }
      ]
    }
  end

  def system_content
    <<~CONTENT
      【注意点】
      JSONのフォーマットで必ず回答してください。
      キーは必ず含ませて、指定したキーを変更はしないでください。
      JSON以外の情報は削除する。
      元のテキストに含まれる文字列だけを値として扱う。
      該当する情報がない場合nullにする。

      回答例は以下の通りです。
      {
        patientName: '山田 太郎',
        doctorName: '鈴木 一郎',
        medicalInstitution: {
          name: 'やくばと病院',
          consultation_category: '整形外科',
          address: '東京都中央区銀座1-2-3',
          tel: '03-1234-5678'
        },
        dispensingDate: '2022-01-15',
        medicines: [
          {
            name: 'ロキソニンEXゲル25mg',
            usage: '1日3回毎食後',
            feature: '熱を下げ、痛みを和らげ、炎症を抑えます。'
          },
          {
            name: 'コリオパンカプセル5mg',
            usage: '1日3回毎食後',
            feature: '内蔵平滑筋のけいれんを抑えたり、胃酸の分泌を抑えることにより、腹痛を和らげます。'
          }
        ]
      }
    CONTENT
  end
end
