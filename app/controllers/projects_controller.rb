class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    p=P.new(:user => current_user, :project => @project)
    ou = p.open_url
    if ou[:success]
      @urls=p.get_urls
      @html=p.get_raw
      if @urls[:success]
        render :edit_parsing
      else
        flash.now[:error] = @urls[:error]
        render :error 
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
        p=params.require(:project).permit(:name, :url)
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
