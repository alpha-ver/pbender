class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.where(:template => false).order(:group)
    if current_user.admin
      @projects = current_user.projects.order(:template, :group)
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    case params[:type]
    when 'skipped'
      @type = 'skipped'
      @fields = @project.fields.where(:enabled => true).all
      @urls   = @project.urls.where(:parse => true, :skip => true)
        .order(:created_at => :desc)
        .paginate(:page => params[:page], :per_page => 50)      
    when 'intask'
      @type = 'intask'
      @fields = @project.fields.where(:enabled => true).all
      @urls   = @project.urls.where(:parse => false, :skip => false)
        .order(:created_at => :desc)
        .paginate(:page => params[:page], :per_page => 50)            
    when 'plugins'
      @type   = 'plugins'
      @fields = @project.fields.where(:enabled => true).all

    else
      @type = 'parsed'
      @fields = @project.fields.where(:enabled => true).all
      @urls   = @project.urls.where(:parse => true, :skip => false)
        .order(:created_at => :desc)
        .paginate(:page => params[:page], :per_page => 1)
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @plugins = Plugin.where(:user_id => current_user.id, :test => true).all
    p=P.new(:user => current_user, :project => @project)
    ou = p.open_url
    if ou[:success]
      @urls=p.get_urls
      @html=p.get_raw
      if @urls[:success] && ( @project.status == "new"    || 
                              @project.status == "finish" || 
                              @project.status == "error"  ||
                              @project.status == "stop")
        render :edit_parsing
      elsif @urls[:success] && (@project.status == "new_task"    || 
                                @project.status == "update_task" || 
                                @project.status == "runing"      ||
                                @project.status == "run"         ||
                                @project.status == "stoping")
        flash.now[:notice] = "Запущенную задачу нельзя редактировать."
        render :task_started
      elsif !@urls[:success]
        flash.now[:error] = @urls[:error]
        render :error 
      else
        flash.now[:error] = "Неизвестное состояние."
        render :type_error        
      end
    else
      flash.now[:error] = ou[:error]
      render :error
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    pp = project_params
    if pp[:success]
      pp.delete(:success)
      @project        = Project.new(pp)
      @project.user   = current_user
      if @project.valid? && @project.save 
        redirect_to edit_project_path(@project), success: "Проект успешно создан."
      else
        flash[:error] = @project.errors
        redirect_to new_project_path(request.parameters)
      end
    else
      flash[:error] = pp[:error]
      redirect_to new_project_path(request.parameters)
    end

  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    pp = project_params
    if pp[:success]
      pp.delete(:success)
      if @project.update(pp)
        redirect_to edit_project_path(@project), success: "Проект успешно обновлен."
      else
        flash.now[:error] = @project.errors
        render :edit
      end
    else
      flash.now[:error] = pp[:error]
      render :edit
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: t('project_was_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      begin
        p=params.require(:project).permit(:name, :url, :group)
        url = URI.parse(p[:url])
        if !url.scheme.nil? || !url.host.nil?
          #test url
          {:success => true, :name => p['name'], :url => url.scheme + '://' + url.host}
        else
          {:success => false, :error => "Ошибочный URL"}
        end
      rescue Exception => e
        {:success => false, :error => e.message}
      end
    end
end
