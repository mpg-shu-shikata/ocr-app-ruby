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
    extracted_response = response.dig('choices', 0, 'message', 'content')
    JSON.parse(extracted_response)
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
      {
        "patient": {
          "name": 患者の氏名を文字列で入力する,
          "birthday": 「生年月日」を「西暦」で入力する,
          "sex": 男はmale、女はfemale、どちらにも属さない場合はotherで入力しなさい
        }
        "medicalInstitution": {
          "name": 処方せんを発行した医療機関を文字列で入力する,
          "code": 医療機関コードを文字列で入力する,
          "consultationCategory": 医療機関の診療科を文字列で入力する,
          "address": 医療機関の住所、所在を入力する,
          "tel": 医療機関の電話番号を入力する
          "doctorName": 医師、保険医の氏名を文字列で入力する,
        },
        "dispensingDate": 「発行日」または「調剤日」を「西暦」で入力する,
        "medicines": [
          {
            "name": 薬の名称を文字列で入力する,
            "usage": '1日3回毎食後'のように用法用量を文字列で入力する,
            "feature": 薬の効果・効能を文字列で入力する,
            "janCode": 13桁もしくは8桁の半角数字を文字列に変換して入力する
          }
        ]
      }

      【注意点】
      JSONのフォーマットで必ず回答してください。
      キーは必ず含ませて、指定したキーを変更はしないでください。
      JSON以外の情報は削除する。
      元のテキストに含まれる文字列だけを値として扱う。
      該当する情報がない場合`null`にする。

      回答例は以下の通りです。
      {
        "patient": {
          "name": "山田 太郎",
          "birthday": "1994-11-12",
          "sex": "female"
        },
        "medicalInstitution": {
          "name": "やくばと病院",
          "code": "12345",
          "consultationCategory": "整形外科",
          "address": "東京都中央区銀座1-2-3",
          "tel": "03-1234-5678",
          "doctorName": "鈴木 一郎"
        },
        "dispensingDate": "2023-01-15",
        "medicines": [
          {
            "name": "ロキソニンEXゲル25mg",
            "usage": "1日3回毎食後",
            "feature": "熱を下げ、痛みを和らげ、炎症を抑えます。",
            "janCode": "4987107610867"
          },
          {
            "name": "コリオパンカプセル5mg",
            "usage": "1日3回毎食後",
            "feature": "内蔵平滑筋のけいれんを抑えたり、胃酸の分泌を抑えることにより、腹痛を和らげます。",
            "janCode": "4987107612345"
          }
        ]
      }
    CONTENT
  end
end
