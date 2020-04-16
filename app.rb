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

  def generic(url, which)
    begin
      html = URI.open(url).read
    rescue
      content_type :json
      halt 400, { error: "Please provide url query parameter and make sure it points to hpc_index.html..." }.to_json
    end

    cov = get_coverage html, which
    prepare_response(cov)
  end

  get "/avg" do
    generic params[:url], "avg"
  end

  get "/top-level-definitions" do
    generic params[:url], "top-level-definitions"
  end

  get "/alternatives" do
    generic params[:url], "alternatives"
  end

  get "/expressions" do
    generic params[:url], "expressions"
  end

end
