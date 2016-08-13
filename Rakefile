# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


def _sig()
  if @signal == "SIGINT"
    @fork_pids.each do |pid|
      Process.kill("HUP", pid)
      Process.wait
    end
    puts "Процессов больше не осталось выходим".
    exit
  end
end


def _global()
  @rake_pid     = Process.pid
  @fork_pids    = []
  @time_start   = Time.now
  @time_current = Time.now  
  @pause_loop   = 30
  @signal       = ""
  @signal_count = 0
  @count_loop   = 0
end



desc "Главный демон"
task :bender => :environment do
  #preloop
  _global()

  Signal.trap("SIGINT"){
    if @rake_pid == Process.pid
      @signal_count +=1
      if @signal == "SIGINT" && @signal_count >  5
        puts "\rАварийная остановка!".colorize(:red)
        exit
      elsif @signal == "SIGINT" && @signal_count <= 5
        puts "\r Погоди немного! Аварийная остановка через - #{6 - @signal_count}".colorize(:red)
      else
        @signal = "SIGINT"
        puts "\r Скоро выключимся!".colorize(:red)
      end
    end
  }

  puts "--- Полетели ---".colorize(:green)

  loop {

    if @signal != "SIGINT" 
      @fork_pids << fork do
        pp = 0
        fork_signal = ""
        Signal.trap("HUP") {
          fork_signal = "HUP"
          puts "Дочерний процесс #{Process.pid} получил HUP.".colorize(:yellow)
        }

        loop{
          


          if fork_signal == "HUP"
            puts "Дочерний процесс #{Process.pid} Завершился.".colorize(:yellow)
            break
          end
        }
      end

    else
      puts "Программа Завершается".colorize(:yellow)
      _sig()
    end

    p @fork_pids
    @count_loop += 1
    sleep @pause_loop
  }

end