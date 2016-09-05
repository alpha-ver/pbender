class PluginsController < ApplicationController
  before_action :set_plugin, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  # GET /plugins
  # GET /plugins.json
  def index
    @plugins = current_user.plugins.all
  end

  # GET /plugins/1
  # GET /plugins/1.json
  def show
  end

  # GET /plugins/new
  def new
    @plugin = Plugin.new
    @out_plugins = list_plugins.map { |e| [info_plugin(e)[:name][I18n.locale], e ] }
  end

  # GET /plugins/1/edit
  def edit
    @out_plugin = info_plugin(@plugin.class_name)
  end

  # POST /plugins
  # POST /plugins.json
  def create
    @plugin = Plugin.new(plugin_params)
    @plugin.user_id = current_user.id

    respond_to do |format|
      if @plugin.save
        format.html { redirect_to edit_plugin_path(@plugin), notice: 'Plugin was successfully created.' }
        format.json { render :show, status: :created, location: @plugin }
      else
        format.html { render :new }
        format.json { render json: @plugin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plugins/1
  # PATCH/PUT /plugins/1.json
  def update

    @plugin.setting = params[:setting]
    @plugin.name    = plugin_params[:name]

    plugin = init_plugin
    pst    = plugin.setting_test
    if pst[:success]
      @plugin.test = true
      @plugin.save
      redirect_to @plugin, notice: 'Plugin was successfully updated.'
    else
      redirect_to edit_plugin_path(@plugin), notice: pst[:error]
    end
  end

  # DELETE /plugins/1
  # DELETE /plugins/1.json
  def destroy
    @plugin.destroy
    respond_to do |format|
      format.html { redirect_to plugins_url, notice: 'Plugin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plugin
      @plugin = Plugin.find_by(:id => params[:id], :user_id => current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plugin_params
      params.require(:plugin).permit(:name, :class_name)
    end

    def list_plugins
      Dir['lib/out/*/plugin.rb'].map { |i|
        "Out#{i.split('/')[-2].gsub('.rb', '').capitalize}"
      } 
    end

    def init_plugin
      #not secure !!!! AAAAAA!!!
      eval(@plugin.class_name).new(@plugin)
    end

    def info_plugin(str)
      eval(str).info
    end
end
