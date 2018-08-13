require 'sqlite3'
require 'fileutils'

module Ush
  class Sqlite
    # An accessor to the underlying Sqlite3::Database instance
    attr_accessor :db

    # Initializes the database connection and creates the table if it doesn't exist already
    def initialize(file = File.expand_path(File.join(File.dirname(__FILE__), '../../../db/ush.sqlite.db')))
      FileUtils.touch(file) unless File.exist?(file) # create the db if it doesnt already exist
      puts "Database is being stored at #{file}"
      @db = SQLite3::Database.new(file)
      @db.execute 'CREATE TABLE IF NOT EXISTS pairings(url TEXT, code TEXT)'
    end

    # Adds a url and shortcode association to the database
    def add_url(url, shortcode)
      @db.execute "INSERT INTO pairings VALUES('#{url}', '#{shortcode}')"
      return true
    rescue SQLite3::Exception => e
      puts 'Unable to add url:'
      puts e
      return false
    end

    # Gets the associated url for the given shortcode
    def get_url_for_code(code)
      statement = @db.prepare("SELECT * FROM pairings WHERE code='#{code}'")
      rs = statement.execute
      rs.each do |row|
        return row[0] # if row.class == Array # This is the first url, shouldn't be more than one.
      end
    rescue SQLite3::Exception => e
      puts "Unable to get url for code #{code}"
      puts e
    end

    # Checks if the given shortcode exists within the database
    def code_exists?(code)
      statement = @db.prepare("SELECT * FROM pairings WHERE code='#{code}'")
      rs = statement.execute
      rs.each do |row|
        return true if row != ''
        return false
      end
    rescue SQLite3::Exception => e
      puts "Unable to get url for code #{code}"
      puts e
    end
  end
end
