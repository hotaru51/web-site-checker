# frozen_string_literal: true

require 'json'
require 'logger'

require_relative 'lib/history_data'
require_relative 'lib/clawler'
require_relative 'lib/dynamodb_history_table'

module WebSiteChecker
  # Lambda handler
  class Handler
    HISTORY_TABLE_NAME = ENV['HISTORY_TABLE_NAME']

    def self.process(event:, context:)
      logger = Logger.new($stdout)
      logger.info("event: #{JSON.generate(event)}")

      url = event['url']
      xpath = event['xpath']
      subject = event['subject']

      # WebページとXPathの文字列取得
      logger.info("fetch web page: url=#{url}, xpath=#{xpath}")
      cl = WebSiteChecker::Clawler.new(url)
      text = cl.search(xpath)
      logger.info("clawler result: #{text}")

      # 新しい履歴データの生成
      new_hist = WebSiteChecker::HistroyData.new
      new_hist.url = url
      new_hist.xpath = xpath
      new_hist.subject = subject
      new_hist.text = text
      logger.info("new history data: #{new_hist}")

      # 前回履歴データの読み込み
      hist_table = WebSiteChecker::DynamoDBHistoryTable.new(HISTORY_TABLE_NAME)
      logger.info("read previous history data: url=#{url}, xpath=#{xpath}")
      prev_hist = hist_table.read_histroy(url, xpath)
      logger.info("previous history data: #{prev_hist}")

      # 前回履歴が存在する場合は前回履歴と比較
      unless prev_hist.nil?
        logger.info("compare text: #{{ new: new_hist.text, prev: prev_hist.text }.to_json}")
        if new_hist.update?(prev_hist)
          logger.info('notify web page updates')
          # TODO: SNS Topicへのpublish実装
        else
          logger.info('web page is not updated')
        end
      end

      {statusCode: 200, body: 'done'}.to_json
    end
  end
end
