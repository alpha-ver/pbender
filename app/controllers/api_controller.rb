class ApiController < ApplicationController
  before_action :set_project
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
      @current_project.tasking  = true
      @current_project.start_at = Time.now
      @current_project.save 
    when "newtask"
      @current_project.status = "new_task"
    when "updtask"
      @current_project.status = "upd_task"
    when "stop"
      Process.kill("HUP", @current_project.pid)
    end

    render :json => {:success => @current_project.save, :params => params}
  end


  private

    def set_project
      if !params[:project].blank?
        if  !params[:project][:id].blank?
          @current_project = current_user.projects.find_by(:id => params[:project][:id])
          if @current_project.nil?
            render :json => {:success => false, :message => "nil", :params => params } 
          end
        else
          render :json => {:success => false, :message => "ok", :params => params } 
        end
      else
        render :json => {:success => false, :message => "ok", :params => params } 
      end
    end

    def set_p
      P.new(:user => current_user, :project => @current_project)
    end


end
