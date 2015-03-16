require './app'

class Migrator
  Sequel.extension :migration

  def self.migrate!
    db = Sequel.connect("postgres://#{ENV['POSTGRESQL_USER']}:#{ENV['POSTGRESQL_PASSWORD']}@#{ENV['POSTGRESQL_HOST']}:5432/#{ENV['POSTGRESQL_DATABASE']}")
    Sequel::Migrator.apply(db, "./db/migrations")
  end
end
