require 'sinatra'
require 'open-uri'
require 'nokogiri'


class App < Sinatra::Base

  set :root, File.dirname(__FILE__)
  enable :sessions

  url_cardano_transactions = "https://input-output-hk.github.io/cardano-transactions/coverage/"

  def get_coverage(url)
    html = URI.open(url).read
    doc = Nokogiri::HTML(html)

    xpath_top_level_definitions = "//th[contains(text(),'Program Coverage Total')]/../td[1]"
    xpath_alternatives = "//th[contains(text(),'Program Coverage Total')]/../td[4]"
    xpath_expressions = "//th[contains(text(),'Program Coverage Total')]/../td[7]"

    cov_top_level_html = doc.xpath(xpath_top_level_definitions).to_s
    cov_alternatives_html = doc.xpath(xpath_alternatives).to_s
    cov_expressions_html = doc.xpath(xpath_expressions).to_s

    cov_top_level = /[0-9]{1,3}%/.match(cov_top_level_html)
    cov_alternatives = /[0-9]{1,3}%/.match(cov_alternatives_html)
    cov_expressions = /[0-9]{1,3}%/.match(cov_expressions_html)

    {
      top_level_definitions: cov_top_level,
      alternatives: cov_alternatives,
      expressions: cov_expressions
    }.to_json
  end

  before do
    content_type :json
  end

  get "/cardano-transactions" do
    get_coverage url_cardano_transactions
  end

end
