require 'pg'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
ROOT_FOLDER = File.join(File.dirname(__FILE__), '../..')
SQL_FILE = File.join(ROOT_FOLDER, INSERT_SQL_FILENAME_HERE)
DB_FILE = File.join(INSERT_DB_FILENAME_HERE)

class DBConnection
  def self.open(db_file_name)
    @db = PG::Connection.open(dbname: db_file_name)
    @db
  end

  def self.reset
    commands = [
      "dropdb '#{DB_FILE}'",
      "createdb '#{DB_FILE}'",
      "psql  '#{DB_FILE}' <  '#{SQL_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.exec(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end