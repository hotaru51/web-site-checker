# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require_relative 'history_data'

module WebSiteChecker
  # Webページからxpathで指定した文字列を取得するクラス
  class Clawler
    USER_AGENT = 'curl/7.88.1'
    attr_accessor :url, :page
    attr_reader :result

    def initialize(url)
      @url = url
      @page = nil
    end

    # Webページを取得する
    # @return [String] Webページbody
    def fetch
      conn = Faraday.new(url, headers: { 'User-Agent': USER_AGENT })
      res = conn.get
      @page = res.body
    end

    # 取得したページを指定したxpathで検索し、文字列を返す
    # 取得できない場合は空文字を返す
    # @parameter xpath [String] XPath
    # @return [String] 検出した文字列
    def search(xpath)
      fetch if @page.nil?
      doc = Nokogiri::HTML.parse(@page)
      target = doc.xpath(xpath)
      @result = target.inner_text
    end
  end
end
