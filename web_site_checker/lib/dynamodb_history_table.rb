# frozen_string_literal: true

require 'time'
require 'aws-sdk-dynamodb'

require_relative 'history_data'

module WebSiteChecker
  # 履歴テーブル操作用クラス
  class DynamoDBHistoryTable
    attr_reader :table

    def initialize(table_name)
      dynamodb_resource = Aws::DynamoDB::Resource.new
      @table = dynamodb_resource.table(table_name)
    end

    # HistroyDataを履歴テーブルに書き込む
    # @param history [WebSiteChecker::HistroyData] 履歴データ
    # @return [Aws::DynamoDB::Types::PutItemOutput] 書き込み結果
    def write_histroy(history)
      hist_item = {
        'url': history.url,
        'xpath': history.xpath,
        'subject': history.subject,
        'text': history.text,
        'date': history.iso_date_str
      }
      @table.put_item(item: hist_item)
    end

    # 履歴テーブルから履歴を取得する
    # @param url [String] URL
    # @param xpath [String] XPath
    # @return [WebSiteChecker::HistroyData] 取得した履歴データ
    # @return [nil] 取得できなかった場合
    def read_histroy(url, xpath)
      hist_key = {
        'url': url,
        'xpath': xpath
      }
      res = @table.get_item(key: hist_key)

      hist_data = nil
      unless res[:item].nil?
        item = res[:item]
        p item
        hist_data = WebSiteChecker::HistroyData.new
        hist_data.url = item['url']
        hist_data.xpath = item['xpath']
        hist_data.subject = item['subject']
        hist_data.text = item['text']
        hist_data.date = Time.parse(item['date'])
      end

      hist_data
    end
  end
end
