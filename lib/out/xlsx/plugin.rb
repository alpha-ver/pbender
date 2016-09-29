#methods#####
# 
#  Class P
#  
#  P.update_progress(project_id, progress)
#  
#  P.prepare_dir(user_id, project_id, plugin_name) 
#    -> {:path=>"1/4/xlsx/", :full_path=>"/home/h0/p/ruby/ap/public/out/1/4/xlsx/"}
#  
#############
class OutXlsx
  # path /lib/out/xlsx/plugin.rb

  #pa   = plugin_activerecord
  #cp   = current project (hash)
  #cpfs = current project fields (hash)
  def initialize(pa=nil, cp=nil, cpfs=nil)
    @cp = cp
    @cpfs = cpfs
    @plugin_name = 'xlsx'
  end

  def self.info
    YAML.load_file("#{Rails.root}/lib/out/xlsx/plugin.yml").deep_symbolize_keys
  end

  #for generated metod
  def before_generate
    @paths     = P.prepare_dir(@cp[:user_id], @cp[:id], @plugin_name)
    @workbook  = RubyXL::Workbook.new
    @worksheet = @workbook.add_worksheet(@cp[:name])
    
    #@worksheet.insert_row(@cpfs.map {|i| i[:name]})
  end

  def generate(result)
    #@worksheet.insert_row( 
    #  result.map {|i| i[:result_text]} 
    #)
  end

  def after_generate
    @workbook.write("#{@paths[:full_path]}file.xlsx")
  end

end