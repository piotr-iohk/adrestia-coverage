require 'sinatra'
require 'open-uri'
require 'nokogiri'

require_relative 'helpers'

class App < Sinatra::Base

  set :root, File.dirname(__FILE__)
  helpers Helpers

  get "/" do
    erb :index
  end

  get "/endpoint" do
    redirect "/endpoint/avg"
  end

  get "/endpoint/:which" do
    begin
      html = URI.open(params[:url]).read
    rescue
      content_type :json
      halt 404, { error: "Please provide url query parameter and make sure it points to hpc_index.html..." }.to_json
    end

    cov = get_coverage html, params[:which]
    prepare_response(cov)
  end
end
