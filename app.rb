require 'rack'
require 'sinatra/base'
require 'sinatra/partial'
require 'slim'

class App < Sinatra::Base
  register Sinatra::Partial

  set :partial_template_engine, :slim
  set :server, :puma

  helpers do
    def date
      DateTime.now.strftime("%d %B %Y")
    end

    def time
      Time.now.strftime("%H:%M")
    end
  end

  get '/' do
    slim :index, layout: :application
  end
end
