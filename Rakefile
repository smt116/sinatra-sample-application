require 'rake'
require 'sequel'
require './app'

APP_FILE = 'app.rb'
APP_CLASS = 'App'

require 'sinatra/assetpack/rake'

autoload :Post, "./models/post"

namespace :db do
  Sequel.extension :migration
  DB = Sequel.connect(App.settings.database)

  task :migrate do
    Sequel::Migrator.run(DB, "db/migrations")
  end

  task :seed do
    random_char =   ->    { (('a'..'z').to_a + [' ']).sample }
    random_string = ->(n) { Array.new(n) { random_char.call }.join }

    128.times do
      title = random_string.call(30)
      body = random_string.call(4096)
      created_at = DateTime.now

      Post.create(title: title, body: body, created_at: created_at)
    end
  end

  namespace :posts do
    task :clean do
      Post.all.each(&:delete)
    end
  end
end
