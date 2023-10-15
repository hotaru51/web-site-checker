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

      {statusCode: 200, body: 'done'}.to_json
    end
  end
end
