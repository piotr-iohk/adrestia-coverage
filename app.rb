require 'sinatra'
require 'open-uri'
require 'nokogiri'


class App < Sinatra::Base

  set :root, File.dirname(__FILE__)
  enable :sessions

  url_cardano_transactions = "https://input-output-hk.github.io/cardano-transactions/coverage/"

  def get_xpath(which)
    case which
    when 'top-level-definitions'
      i = "1"
    when 'alternatives'
      i = "4"
    when 'expressions'
      i = "7"
    else
      i = "1"
    end
    "//th[contains(text(),'Program Coverage Total')]/../td[#{i}]"
  end

  def get_coverage(url, which)
    html = URI.open(url).read
    doc = Nokogiri::HTML(html)
    xpath = get_xpath(which)

    cov_html = doc.xpath(xpath).to_s
    cov = /[0-9]{1,3}/.match(cov_html)
    cov
  end

  def prepare_response(cov)
    case cov.to_s.to_i
    when 0..30
      color = "red"
    when 30..50
      color = "orange"
    when 50..70
      color = "yellow"
    when 70..80
      color = "yellowgreen"
    when 80..90
      color = "green"
    when 90..100
      color = "brightgreen"
    end
    {
      schemaVersion: 1,
      label: "Coverage",
      message: "#{cov}%",
      color: color
    }.to_json
  end

  before do
    content_type :json
  end

  get "/cardano-transactions" do
    redirect "/cardano-transactions/top-level-definitions"
  end
  get "/cardano-transactions/:which" do
    cov = get_coverage url_cardano_transactions, params[:which]
    prepare_response(cov)
  end

end
