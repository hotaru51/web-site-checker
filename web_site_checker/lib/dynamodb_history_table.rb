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
  end
end
