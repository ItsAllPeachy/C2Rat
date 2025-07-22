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
  options = prompt.select("What Are You Managing =>") do |menu|
    menu.choice "SERVER"
    menu.choice "CLIENTS"
    menu.choice "DATABASE"
    menu.choice "LEAVE".red
  end
  case options
    when "SERVER"
      puts "selected choice => SERVER menu".blue
    when "CLIENTS"
      puts "selected choice => CLIENT menu".blue
    when "DATABASE"
      puts "selected choice => DATABASE menu".blue
      database_menu
    when "LEAVE".red
      puts "selected choice => new menu".blue
      exit
  end
end

def database_menu
  dbfile = "../server/bin/assets/db/db.db"
  db = SQLite3::Database.new(dbfile)
  puts "\n"
  puts "in DATABASE menu"
  prompt = TTY::Prompt.new
  options = prompt.select("Pick an action".blue) do |menu|
    menu.choice "CLEAR DATABASE"
    menu.choice "DELETE FROM"
    menu.choice "VIEW CLIENTS"
    menu.choice "BACK".red
    menu.choice "LEAVE".red
  end
  case options
    when "CLEAR DATABASE"
      puts "CLEAR DATABASE SELECTED".red
    when "DELETE FROM"
      puts "DELETE FROM SELECTED".red
      database_menu_delete(db)
    when "VIEW CLIENTS"
      puts "VIEW CLIENTS SELECTED".red
      database_menu_clients(db)
    when "BACK"
      tui
    when "LEAVE"
      exit
  end
end

def database_menu_delete(db)
  rows = db.execute("SELECT * FROM users")
  if rows.empty?
    puts "TABLE USERS => no valid db entries"
    return
  end
  prompt = TTY::Prompt.new
  selected_id = prompt.select("select user to delete \n".blue) do |menu|
    rows.each do |row|
      id, created, modified, ip = row
      display = "ID: #{id.to_s.ljust(3)} | IP: #{ip.to_s.ljust(15)} | Created: #{created} | Modified: #{modified}"
      menu.choice display, id
    end
  end
  db.execute("DELETE FROM users WHERE id = ?", selected_id)
  puts "User #{selected_id} deleted.".red
end


def database_menu_clients(db)
  rows = db.execute("SELECT * FROM users")
  if rows.empty?
    puts "TABLE users => empty"
    return
  end
  prompt = TTY::Prompt.new
  prompt.select("clients in db \n".blue) do |menu|
    rows.each do |row|
      id, created, modified, ip = row
      display = "ID: #{id.to_s.ljust(3)} | IP: #{ip.to_s.ljust(15)} | Created: #{created} | Modified: #{modified}"
      menu.choice display
    end
  end
end

tui
