require 'colorize'
require 'tty-prompt'
require 'tty-table'
require 'sqlite3'

def tui
  puts "\n"
  puts " ██▀███   ▄▄▄     ▄▄▄█████▓▄▄▄█████▓▓█████  ███▄    █     ███▄ ▄███▓ ▄▄▄       ███▄    █  ▄▄▄        ▄████ ▓█████  ██▀███".red
  puts "▓██ ▒ ██▒▒████▄   ▓  ██▒ ▓▒▓  ██▒ ▓▒▓█   ▀  ██ ▀█   █    ▓██▒▀█▀ ██▒▒████▄     ██ ▀█   █ ▒████▄     ██▒ ▀█▒▓█   ▀ ▓██ ▒ ██▒".red
  puts " ▓██ ░▄█ ▒▒██  ▀█▄ ▒ ▓██░ ▒░▒ ▓██░ ▒░▒███   ▓██  ▀█ ██▒   ▓██    ▓██░▒██  ▀█▄  ▓██  ▀█ ██▒▒██  ▀█▄  ▒██░▄▄▄░▒███   ▓██ ░▄█ ▒".red
  puts "▒██▀▀█▄  ░██▄▄▄▄██░ ▓██▓ ░ ░ ▓██▓ ░ ▒▓█  ▄ ▓██▒  ▐▌██▒   ▒██    ▒██ ░██▄▄▄▄██ ▓██▒  ▐▌██▒░██▄▄▄▄██ ░▓█  ██▓▒▓█  ▄ ▒██▀▀█▄".red
  puts "░██▓ ▒██▒ ▓█   ▓██▒ ▒██▒ ░   ▒██▒ ░ ░▒████▒▒██░   ▓██░   ▒██▒   ░██▒ ▓█   ▓██▒▒██░   ▓██░ ▓█   ▓██▒░▒▓███▀▒░▒████▒░██▓ ▒██▒".red
  puts "░ ▒▓ ░▒▓░ ▒▒   ▓▒█░ ▒ ░░     ▒ ░░   ░░ ▒░ ░░ ▒░   ▒ ▒    ░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒░   ▒ ▒  ▒▒   ▓▒█░ ░▒   ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░".red
  puts "  ░▒ ░ ▒░  ▒   ▒▒ ░   ░        ░     ░ ░  ░░ ░░   ░ ▒░   ░  ░      ░  ▒   ▒▒ ░░ ░░   ░ ▒░  ▒   ▒▒ ░  ░   ░  ░ ░  ░  ░▒ ░ ▒░".red
  puts "   ░░   ░   ░   ▒    ░        ░         ░      ░   ░ ░    ░      ░     ░   ▒      ░   ░ ░   ░   ▒   ░ ░   ░    ░     ░░   ░".red
  puts "    ░           ░  ░                    ░  ░         ░           ░         ░  ░         ░       ░  ░      ░    ░  ░   ░".red
  main_menu
end

def self.main_menu
  puts "\n"
  prompt = TTY::Prompt.new
  options = prompt.select("What Are You Managing") do |menu|
    menu.choice "   SERVER  "
    menu.choice "   CLIENTS "
    menu.choice "   DATABASE"
    menu.choice "   LEAVE   ".red
  end
  case options
    when "   SERVER  "
      puts "selected choice => SERVER menu".blue
      server_menu
    when "   CLIENTS "
      puts "selected choice => CLIENT menu".blue
      client_menu
    when "   DATABASE"
      puts "selected choice => DATABASE menu".blue
      database_menu
    when "   LEAVE   ".red
      puts "selected choice => new menu".blue
      exit
  end
end

def self.server_menu
  puts "in SERVER menu"
end
def self.client_menu
  puts "in CLIENT menu"
end
def self.database_menu
  dbfile = "../server/bin/assets/db/db.db"
  db = SQLite3::Database.new(dbfile)
  puts "\n"
  puts "in DATABASE menu"

  rows = db.execute("SELECT * FROM users")
  db.close

  if rows.empty?
    puts "TABLE users => empty"
    return
  end

  promp = TTY::Prompt.new

  promp.select("clients in db \n".blue) do |menu|
    rows.each do |row|
      id, created, modified, ip = row
      display = "ID: #{id.to_s.ljust(3)} | IP: #{ip.to_s.ljust(15)} | Created: #{created} | Modified: #{modified}"
      menu.choice display
    end
  end
end

tui
