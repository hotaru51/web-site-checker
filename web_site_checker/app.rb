# frozen_string_literal: true

require 'json'

module WebSiteChecker
  class Handler
    def self.process(event:, context:)
      {statusCode: 200, body: 'Web site checker function'}.to_json
    end
  end
end
