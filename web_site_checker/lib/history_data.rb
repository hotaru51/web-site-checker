# frozen_string_literal: true

require 'time'
require 'json'

module WebSiteChecker
  # 履歴データクラス
  class HistroyData
    attr_accessor :url, :xpath, :subject, :text, :date

    def initialize
      @url = nil
      @xpath = nil
      @subject = nil
      @text = nil
      @date = Time.now.localtime('+09:00') # 日本時間にする
    end

    # textを比較し、変更があればtrueを返す
    # @param history [WebSiteChecker::HistroyData] 新しい履歴データ
    # @return [Boolean] 更新有無
    def update?(history)
      @text != history.text
    end

    # ISO 8601形式の日付を返す
    # @return [String] ISO 8601表記の日付文字列
    def iso_date_str
      @date.strftime('%FT%T%z')
    end

    # 履歴データのプロパティをJSON文字列で返す
    # @return [String] 履歴データのJSON文字列
    def to_s
      {
        url: @url,
        xpath: @xpath,
        subject: @subject,
        text: @text,
        date: iso_date_str
      }.to_json
    end
  end
end
