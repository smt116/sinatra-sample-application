require "rack"

require "sinatra/base"
require "sinatra/partial"
require "sinatra/sequel"

require "slim"
require "dotenv"

Dotenv.load

class App < Sinatra::Base
  register Sinatra::Partial
  autoload :Post, "./models/post"

  configure do
    set :partial_template_engine, :slim
    set :server, :puma
    set :database, "postgres://#{ENV["POSTGRESQL_USER"]}:#{ENV["POSTGRESQL_PASSWORD"]}@#{ENV["POSTGRESQL_HOST"]}:5432/#{ENV["POSTGRESQL_DATABASE"]}"
  end

  before do
    Sequel.connect(settings.database)
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

  get "/posts" do
    @posts = Post.limit(15)
    slim :posts, layout: :application
  end

  post "/posts/new" do
    Post.create(title: params["title"],
      body: params["body"],
      created_at: DateTime.now)

    redirect '/'
  end
end
