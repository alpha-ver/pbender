class ApiController < ApplicationController
  before_action :set_project, except: [:get_generate_progress]
  before_action :authenticate_user!


  #POST /api/add_field
  def add_field
    field = @current_project.fields.find_by(:name => params[:field_add])
    if field.nil?
      field = Field.new(:name => params[:field_add],:project_id => @current_project.id)
      if field.valid? && field.save
        render :json => {:success => true, :message => "Поле #{params[:field_add]} добавленно", :params => params, :field => field }
      else
        render :json => {:success => false, :message => field.error.messages, :params => params }
      end 
    else
      render :json => {:success => false, :message => "Поле #{params[:step3_field_add]} уже существует", :params => params }
    end
  end

  #POST /api/get_fields
  def get_fields
    fields = @current_project.fields.order(:id).all
    render :json => {:success => true, :fields => fields}
  end

  #POST /api/get_html
  def get_html
    p=set_p
    r=p.open_url(params[:current_url])
    if r[:success]
      render :json => {:success => true, :result_highlight => p.get_highlight()}
    else
      render :json => {:success => false, :error => r[:error]}
    end
  end

  def delete_field
    field = @current_project.fields.find_by(:name => params[:field][:name])
    if field.nil?
      render :json => {:success => false}
    else
      field.delete
      render :json => {:success => true}
    end
  end

  #POST /api/edit_field
  def edit_field
    if !params[:field].blank? && !params[:field][:name].blank?
      current_field=@current_project.fields.find_by(:name => params[:field][:name])

      current_field.setting = {
        :xpath    => params[:field][:setting][:xpath],
        :attr     => params[:field][:setting][:attr],
        :regex    => params[:field][:setting][:regex],
        :download => params[:field][:setting][:download]
      }

      current_field.otype    = params[:field][:otype]
      current_field.unique   = params[:field][:unique]
      current_field.required = params[:field][:required] 
      current_field.enabled  = params[:field][:enabled]

      p = set_p
      if p.open_url(params[:current_url])[:success]
        res = p.get_result_field(current_field)
        if res[:success]
          current_field.ok = true

          render :json => {:success => current_field.save, :result => res[:result], :field=>current_field, :result_highlight => res[:result_highlight]}
        else
          render :json => {:success => false, :error => res[:error]}
        end
      else
        render :json => {:success => false, :error => "Ошибка соединения с сервером"}
      end

    else
      render :json => {:success => false, :error => ""}
    end

  end


  def upd_project_setting
    @current_project.setting = params[:project][:setting]
    if @current_project.valid?
        render :json => { :success => @current_project.save, :params => params}
    else
      render :json => {:success => false, :error => "Ошибка сохранения!"}
    end
  end

  def controll_task
    case params[:project][:status]
    when "tasking"
      if !@current_project.pid.blank? && Process.exists?(@current_project.pid)
        success = false
      else
        if params[:project][:enabled] == "on"
          @current_project.tasking  = true

          p params[:project][:interval].to_i

          if params[:project][:interval].blank? || params[:project][:interval].to_i < 30
            interval = 1800
          else
            interval = params[:project][:interval].to_i * 60
          end
          @current_project.interval = interval
        else
          @current_project.tasking = false
        end 

        @current_project.start_at = Time.now
        success = @current_project.save 
      end

    when "newtask"
      @current_project.status = "new_task"
      success = @current_project.save
    when "updtask"
      @current_project.status = "upd_task"
      success = @current_project.save
    when "stop"
      Process.kill("HUP", @current_project.pid)
    end

    render :json => {:success => success, :params => params, :project => @current_project}
  end

  def get_generate_setting
    if params[:plugin].blank?
      render json => {:success => false, :error=> {:message => "Params error"}}
    else
      pp = params[:plugin]
      if P.list_plugins(:generate, false).include?(pp)
        plugin_info = eval(pp).info
        if plugin_info[:setting].blank?
          plugin_temlate = nil
        else
          plugin_teplate = Plugin.where(:class_name => pp, :user_id => current_user.id)
        end
        render :json => {:success => true, :plugin_info => plugin_info, :plugin_temlate => plugin_temlate}
      else
        render :json => {:success => false, :error=> {:message => "Invalid plugin"}}
      end
    end
  end

  def add_task_generating
    gp = Project.find_by(:status => ['generate', 'task_generate', 'stopping_generate'], :user_id => current_user.id)
    if gp.nil?
      if @current_project.status == 'stop' || @current_project.status == "finish"
      
        pp = params[:plugin]
        if P.list_plugins(:generate, false).include?(pp)
          @current_project
          @current_project.status = 'task_generate'
          @current_project.save

          fork_pid = fork do
            sleep 3 # - fix save pids
            @current_project.status = 'generate'
            @current_project.save

            #инициализация плагина
            plugin = eval(pp).new(
              nil, #cetting ;(
              @current_project.serializable_hash.deep_symbolize_keys, 
              #@current_project.fields.all.map {|i| i.serializable_hash.deep_symbolize_keys} -> github pff
              Hash[
                @current_project.fields.map {|i| 
                  [
                    i[:id], 
                    i.serializable_hash(:except=>:id).deep_symbolize_keys
                  ] 
                }
              ]
            )
            #Поиск всех нормальны url 
            urls = @current_project.urls.where(:parse=> true, :skip=> false)
            #

            plugin.before_generate(urls.count)

            urls.each do |url|
              url_h   = url.serializable_hash.deep_symbolize_keys
              results = url.results.map {|i| i.serializable_hash.deep_symbolize_keys}
              plugin.generate(url_h, results)
            end
            
            result = plugin.after_generate()

            #заканчиваем с плагинами
            pid = @current_project.pid
            @current_project.result = result
            @current_project.status = 'stopping_generate'
            @current_project.pid    = nil
            @current_project.save
           
          
            # Плодим зомби! Разобраться бы.
          end

          @current_project.pid = fork_pid
          @current_project.save

          render :json => {:success => true}
        else
          render :json => {:success => false, :error=> {:message => "Такого плагина не существует."}}
        end
      else
         render :json => {:success => false, :error=> {:message => "В начале отсановите задачу — <b>#{@current_project.name}</b>"}}
      end
    else
      render :json => {:success => false, :error=> {:message => "Дождитесь завершения генерации задачи — <b>#{gp.name}</b>."}}
    end
  end


  def get_generate_progress
    pg = Project.find_by(:status => ['generate', 'task_generate', 'stopping_generate'], :user_id => current_user.id)
    if pg.nil?
      render :json => {:success => false}
    else
      if pg.status == 'stopping_generate'
        pg.status = 'finish'
        pg.save
      end
      render :json => {:success => true, :status => pg.status, :progress => pg.progress, :name => pg.name, :url=> pg.result['plugin_file_url']}
    end
  end

  private

    def set_project
      if !params[:project].blank? && params[:project].class == ActionController::Parameters #<- array ???
        if  !params[:project][:id].blank?
          @current_project = current_user.projects.find_by(:id => params[:project][:id])
          if @current_project.nil?
            render :json => {:success => false, :message => "nil", :params => params } 
          end
        else
          render :json => {:success => false, :message => "ok", :params => params } 
        end
      else
        render :json => {:success => false, :message => "ok", :params => params} 
      end
    end


    def set_p
      P.new(:user => current_user, :project => @current_project)
    end

end
