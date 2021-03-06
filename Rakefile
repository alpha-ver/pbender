# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


def _sig()
  if @signal == "SIGINT"
    puts "Процессов больше не осталось выходим!".colorize(:red)
    exit
  end
end


def _global()
  @rake_pid     = Process.pid
  @fork_pids    = []
  @time_start   = Time.now
  @time_current = Time.now  
  @pause_loop   = 3
  @signal       = ""
  @signal_count = 0
  @count_loop   = 0
end

def get_task
  begin
    p=Project.find_by(:status => ["new_task", "update_task"], :pid => nil)
    if p.nil?
      p=Project.where("start_at < '#{Time.now.utc}' AND tasking = true AND pid is null AND status IN ('stop', 'finish')").first
      if !p.nil?
        p.start_at = Time.now + p.interval
      end
    end

    if !p.nil?
      p.pid = 0
    end   
    
    p

  rescue Exception => ex
    begin
      ActiveRecord::Base.connection.reconnect!
      puts "Reconect DB".colorize(:red)
    rescue
      sleep 10
      retry # will retry the reconnect
    else
      retry # will retry the database_access_here call
    end
  end
end


def plugin_out(out, current_url, results)
  if !out.nil?
    cu = current_url.serializable_hash.deep_symbolize_keys
    rs = results.map {|i| i.serializable_hash.deep_symbolize_keys}
    out.push_url(cu, rs)
  else
    nil
  end
end

def init_out(cp, cpfs)
  if !cp.setting.nil? && !cp.setting['plugin'].nil? && !cp.setting['plugin']['id'].nil?
    plugin = Plugin.find_by(:id => cp.setting['plugin']['id'], :test => true)
    if !plugin.nil?
      #todo test safe eval
      eval(plugin.class_name).new(
        plugin, 
        cp.serializable_hash.deep_symbolize_keys, 
        #cpfs.map {|i| i.serializable_hash.deep_symbolize_keys} -> github теперь переделать!
        Hash[
          cpfs.map {|i| 
            [
              i[:id], 
              i.serializable_hash(:except=>:id).deep_symbolize_keys
            ] 
          }
        ]



      )  
    else 
      nil
    end    
  else
    nil
  end
end


desc "Главный демон"
task :bender => :environment do

  `echo "#{Process.pid}" > #{Rails.root}/tmp/pids/metrics_gen.pid`
  `echo "#{Process.ppid}" > #{Rails.root}/tmp/pids/metrics_gen.ppid`

  #preloop
  _global()

  ['SIGINT', 'SIGTERM'].each do |s|
    Signal.trap(s){
      if @rake_pid == Process.pid
        @signal_count +=1
        if @signal == "SIGINT" && @signal_count >  5
          puts "\rАварийная остановка!".colorize(:red)
          exit
        elsif @signal == "SIGINT" && @signal_count <= 5
          puts "\rПогоди немного! Аварийная остановка через - #{6 - @signal_count} нажатий.".colorize(:red)
        else
          @signal = "SIGINT"
          puts "\nСкоро выключимся!".colorize(:red)
          @fork_pids.each do |pid|
            begin
              Process.kill("HUP", pid)
              Process.wait
            rescue Exception => e
              puts "\rОшибка завершения процесса #{pid}.".colorize(:red)
            end
          end
        end
      end
    }
  end

  puts "--- Полетели ---".colorize(:green)

  loop {
    if @signal != "SIGINT" 
      #проверяем проекты
      current_project = get_task

      if !current_project.nil?
        
        puts "Найден новый процесс #{current_project.name} - #{current_project.url}" 
        current_project.status = "runing"
        current_project.save 
        #FORK
        @fork_pids << fork do
          begin
            fork_signal = ""
            Signal.trap("HUP") {
              fork_signal = "HUP"
              puts "Дочерний процесс #{Process.pid} получил HUP.".colorize(:yellow)
            }
            #####################################################################
            ########################## Тело парсера #############################
            #####################################################################
            current_user   = current_project.user
            current_fields = current_project.fields.where(:enabled => true).order(:created_at).all
            current_urls   = current_project.urls.where(:parse => false).all
            p = P.new(:user => current_user, :project => current_project)
            out = init_out(current_project, current_fields)
            current_project.status = "run"
            current_project.pid = Process.pid
            current_project.save
            task_run  = 1
            only_path = nil

            #тип парсинга
            if !current_project.setting.blank?
              while task_run == 1 do
                if current_project.setting['option_url'] == "recursion"
                  if Url.find_by(:project_id => current_project.id).blank?
                    #Первый запуск
                    current_url = Url.new(:url => "/", :project_id => current_project.id)
                    p.open_url("/")
                    urls = p.get_urls

                    if urls[:success]
                      puts  "Первый запуск '#{current_project.name}/#{current_user.email}" + 
                            "найденно #{urls[:result].count} ссылок".colorize(:green)
                      urls[:result].delete("/")
                      Url.transaction do
                        urls[:result].each do |url|
                          Url.new(:url => url, :project_id => current_project.id).save
                        end
                      end

                    else
                      current_url.log = urls[:error]
                    end

                  elsif !current_urls.blank? || (current_project.tasking && only_path == nil)
                    
                    if current_urls.blank?
                      if current_project.setting['only_path_field'].blank?
                        current_url = Url.find_by(:url => "/", :project_id => current_project.id)
                      else
                        current_url = Url.find_by(:url => current_project.setting['only_path_field'], 
                                                  :project_id => current_project.id)
                        if current_url.nil?
                          current_url = Url.new(:url => current_project.setting['only_path_field'], 
                                                :project_id => current_project.id)
                          current_url.save!
                        end
                      end
                    else
                      current_url = current_urls[0]
                    end

                    ###брать ссылки только с 1 страницы
                    if only_path.nil?
                      if !current_project.setting.blank? && current_project.setting['only_path'] == "true"                    
                        if current_project.setting['only_path_field'].blank?
                          p.open_url
                          only_path = 1
                        else
                          p.open_url(current_project.setting['only_path_field'])
                          only_path = 1  
                        end  
                      else
                        p.open_url(current_url.url)
                      end

                    else
                      p.open_url(current_url.url)
                    end

                    #пропускаем парсин
                    if only_path.nil? || only_path == 1
                      #если брали ссылку то 1 и возьмем ссылки 1 раз
                      if only_path == 1
                        only_path = 2
                      end

                      urls = p.get_urls
                      if urls[:success]
                        exist_url = Url.where(:url => urls[:result], :project_id => current_project.id).all
                        if exist_url.blank?
                          urls[:result].each do |url|
                            Url.new(:url => url, :project_id => current_project.id).save
                          end
                        else

                          urls[:result] = urls[:result] - exist_url.map {|i| i.url} - [current_url.url]
                        
                          if ![:result].blank?
                            urls[:result].each do |url|
                              Url.new(:url => url, :project_id => current_project.id).save
                            end
                          end
                        end
                      end
                    end

                    if current_urls.blank?
                      current_urls = current_project.urls.where(:parse => false).all
                    else
                      current_urls = current_urls - [current_url]
                    end

                  else
                    puts "Задача #{current_project.name} Завершенна.".colorize(:green)
                    current_project.status = "finish"
                    current_project.pid = nil
                    current_project.save
                    break
                    #update

                  end

                elsif current_project.setting['option_url'] == "range"

                elsif current_project.setting['option_url'] == "list"
                
                else 
                  current_project.result = {:error => "Не известный option_url"}
                  current_project.save
                  break
                end

                #проверка
                if current_url.url != p.get_url
                  current_url = Url.find_or_create_by(:url => p.get_url, :project_id => current_project.id)
                end
                  current_url_sha   = p.get_sha
                  current_url.parse = true
                  current_url.sha   = current_url_sha

                ###Парсим
                if p.url_skip?
                  current_url.skip  = true
                  current_url.log   = "Пропущенно по рекурсивным настройкам."
                  current_url.save!
                else
                  duble = current_project.urls.find_by(:duble => false, :sha => current_url_sha)
                  if duble.nil?
                    required = true; unique = true
                    results  = []
                    current_fields.each do |cf|
                      rf = p.get_result_field(cf)
                      if rf[:success]
                        ###############################
                        ####Проверкка на уникальность## 
                        if cf.unique
                          if cf.otype == "text" || cf.otype == "html" || cf.otype == "attr"
                            result = cf.results.find_by(:result_text => rf[:result])
                            if !result.blank?
                              unique = false
                            end
                          elsif cf.otype == "array" || cf.otype == "array_attr"
                            result = cf.results.find_by(:result_arr => rf[:result].map{|i| i.to_s})
                            if !result.blank?
                              unique = false
                            end
                          end
                        end 
                        ################################
                        ####Проверка на пустое значение#
                        if cf.required 
                          if rf[:result].blank?
                            required = false
                          end
                        end

                        ########################################
                        #Если все нормально сохраняем результат#
                        ########################################
                        if required || unique
                          if cf.otype == "text" || cf.otype == "html" || cf.otype == "attr"
                            result=Result.new(
                              result_text: rf[:result],
                              success: true,  
                              url_id: current_url.id, 
                              field_id: cf.id
                            )
                          elsif cf.otype == "array" || cf.otype == "array_attr"
                            result=Result.new( 
                              result_arr: rf[:result],
                              success: true,  
                              url_id: current_url.id, 
                              field_id: cf.id
                            )                          
                          end
                          results << result
                          result.save!
                          current_url.skip  = false
                          current_url.save!
                        else
                          current_url.skip  = true
                          current_url.log   = "Пропушенно по настройкам пользователя" + 
                                              "#{required ? '' : 'пустой'}" + 
                                              "#{unique   ? '' : ', не уникальный'}."
                          current_url.save
                        end
                      end
                    end
                    # each fields end


                    # fix fields
                    if required && unique
                      #plugin out
                      print " Out -> #{current_url.url}".colorize(:green)
                      plugin_out(out, current_url, results)
                    else
                      if !current_url.results.blank?
                        print "Fix!".colorize(:red)
                        current_url.results.each {|i| i.delete}
                      end
                    end

                  else
                    #######Дубль по sha
                    current_url.skip     = true
                    current_url.duble    = true
                    current_url.duble_id = duble.id
                    current_url.sha      = current_url_sha
                    current_url.log      = "Пропущенно. Является дублирующей страницей."
                    current_url.save!
                  end
                end

                if current_urls.count <= 1
                  current_urls = current_project.urls.where(:parse => false).all     
                end

                if current_urls.blank?
                  puts "Парсин #{current_project.name} Завершенн. Выгрузка @todo"

                  puts "Задача #{current_project.name} Завершенна."
                  current_project.status = "finish"
                  current_project.pid = nil
                  current_project.save
                  current_project = nil
                  task_run = 0
                end

                sleep sprintf("%.2f", rand(228)/100.0 + 0.8).to_f

                if fork_signal == "HUP"
                  puts "Дочерний процесс #{Process.pid} Завершился.".colorize(:yellow)
                  task_run = 0
                  current_project.status = "stop"
                  current_project.pid = nil
                  current_project.save
                  current_project = nil
                end

              end
              #print "-"
            else
              current_project.result = {:error => "Не заполенны настройки!"}
              current_project.status = "error"
              current_project.pid = nil
              current_project.save
            end

          rescue => e
            puts "Произошла ошибка в Задаче #{current_project.id}/#{current_project.name}".colorize(:red)
            puts "Error during processing: #{$!}".colorize(:red)
            puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"

            current_project.pid     = nil
            current_project.status  = 'error'
            current_project.tasking = false
            current_project.result  = {
              :exeption  => e.message,
              :backtrace => e.backtrace 
            }

            current_project.save
          end
        end #end Fork

      else
        print "\rНовых проектов не найденно: цикл #{@count_loop}, аптайм #{(@time_current - @time_start).to_i}сек.".colorize(:yellow)
      end
    else
      _sig()
    end

    @count_loop += 1
    @time_current = Time.now
    sleep @pause_loop
  }

end


desc "Task After Deploy"
task :after_deploy => :environment  do
  File.symlink "/app/bender/current/public/pf", "/app/bender/shared/public/pf"

end