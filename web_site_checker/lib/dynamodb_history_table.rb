# frozen_string_literal: true

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
  end
end
