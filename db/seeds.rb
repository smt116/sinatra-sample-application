require "sequel"
require "slim"
require "dotenv"

Dotenv.load

DB = Sequel.connect("postgres://#{ENV["POSTGRESQL_USER"]}:#{ENV["POSTGRESQL_PASSWORD"]}@#{ENV["POSTGRESQL_HOST"]}:5432/#{ENV["POSTGRESQL_DATABASE"]}")

require './models/post'

def random_char
  (('a'..'z').to_a + [' '])[rand(27)]
end

1000.times do
  title = (0..16).map { (('a'..'z').to_a + [' '])[rand(27)] }.join
  body = (0..1024).map { (('a'..'z').to_a + [' '])[rand(27)] }.join
  created_at = DateTime.now

  Post.create(title: title, body: body, created_at: created_at)
end
