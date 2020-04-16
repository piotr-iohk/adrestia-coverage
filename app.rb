require 'sinatra'
require 'open-uri'
require 'nokogiri'

require_relative 'helpers'

class App < Sinatra::Base

  set :root, File.dirname(__FILE__)
  helpers Helpers

  url_cardano_transactions = "https://input-output-hk.github.io/cardano-transactions/coverage/"
  url_cardano_coin_selection = "https://input-output-hk.github.io/cardano-coin-selection/coverage/"

  get "/" do
    erb :index
  end

  # /cardano-transactions
  get "/cardano-transactions" do
    redirect "/cardano-transactions/top-level-definitions"
  end

  get "/cardano-transactions/:which" do
    cov = get_coverage url_cardano_transactions, params[:which]
    prepare_response(cov)
  end

  # /cardano-coin-selection
  get "/cardano-coin-selection" do
    redirect "/cardano-coin-selection/top-level-definitions"
  end

  get "/cardano-coin-selection/:which" do
    cov = get_coverage url_cardano_coin_selection, params[:which]
    prepare_response(cov)
  end

end
