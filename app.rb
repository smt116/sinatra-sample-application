require "rack"

require "sinatra/base"
require "sinatra/partial"
require "sinatra/assetpack"

require "slim"
require "dotenv"

Dotenv.load

class App < Sinatra::Base
  register Sinatra::Partial
  register Sinatra::AssetPack

  configure do
    set :root, File.dirname(__FILE__)
    set :partial_template_engine, :slim
    set :server, :puma
  end

  assets do
    serve '/stylesheets', from: 'assets/stylesheets'
    serve '/images',      from: 'assets/images'

    prebuild true
    expires 86400*365, :public

    css :application, '/stylesheets/application.css', [
      '/stylesheets/custom.css',
      '/stylesheets/sticky-footer.css'
    ]

    css_compression :simple
  end

  helpers do
    def date
      DateTime.now.strftime("%d %B %Y")
    end

    def time
      Time.now.strftime("%H:%M")
    end
  end

  get "/" do
    slim :index, layout: :application
  end
end
