require 'sinatra'
require 'open-uri'
require 'nokogiri'

require_relative 'helpers'

class App < Sinatra::Base

  set :root, File.dirname(__FILE__)
  helpers Helpers

  url_cardano_transactions = "https://input-output-hk.github.io/cardano-transactions/coverage/hpc_index.html"
  url_cardano_coin_selection = "https://input-output-hk.github.io/cardano-coin-selection/coverage"

  def generic(url, which)
    html = URI.open(url).read
    cov = get_coverage html, which
    prepare_response(cov)
  end

  get "/" do
    erb :index
  end

  # /cardano-transactions
  get "/cardano-transactions" do
    generic url_cardano_transactions, "avg"
  end

  get "/cardano-transactions/:which" do
    generic url_cardano_transactions, params[:which]
  end

  # /cardano-coin-selection
  get "/cardano-coin-selection" do
    generic url_cardano_coin_selection, "avg"
  end

  get "/cardano-coin-selection/:which" do
    generic url_cardano_coin_selection, params[:which]
  end

end
