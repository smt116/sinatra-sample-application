require "rack"

require "sinatra/base"
require "sinatra/partial"
require "sinatra/sequel"
require "sinatra/assetpack"

require "slim"
require "dotenv"

Dotenv.load

class App < Sinatra::Base
  register Sinatra::Partial
  register Sinatra::AssetPack

  autoload :Post, "./models/post"

  configure do
    set :root, File.dirname(__FILE__)
    set :static_cache_control, [:public, {max_age: 86400}]
    set :partial_template_engine, :slim
    set :server, :puma
    set :database, ENV.fetch("DATABASE_URL")
  end

  before do
    Sequel.connect(settings.database, max_connections: ENV.fetch("MAX_THREADS", 16).to_i)
  end

  assets do
    serve '/stylesheets', from: 'assets/stylesheets'
    serve '/images',      from: 'assets/images'

    prebuild true

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

  get "/posts" do
    slim :posts, layout: :application, locals: { posts: Post.order(Sequel.lit("RANDOM()")).limit(15) }
  end

  post "/posts/new" do
    Post.create(title: params["title"],
                body: params["body"],
                created_at: DateTime.now)

    redirect "/"
  end
end
