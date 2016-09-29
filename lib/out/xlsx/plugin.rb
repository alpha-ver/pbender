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
    @cp          = cp
    @cpfs        = cpfs
    @plugin_name = 'xlsx'
  end

  def self.info
    YAML.load_file("#{Rails.root}/lib/out/xlsx/plugin.yml").deep_symbolize_keys
  end

  #for generated metod
  def before_generate(count=nil)
    #Prepare workbook
    @count                = count
    @num                  = 0
    @column_indexs        = {}

    @paths                = P.prepare_dir(@cp[:user_id], @cp[:id], @plugin_name)
    @workbook             = RubyXL::Workbook.new
    @worksheet            = @workbook[0]
    @worksheet.sheet_name = @cp[:name]

    # Add top row -> add_cell(row_index = 0, column_index = 0, data = '', formula = nil, overwrite = true) ⇒ Object 
    # add serwice row
    @start_row = 1
    # add service column
    @worksheet.add_cell(0, 0, 'url')

    @cpfs.each_with_index.map do |v,i|
      @worksheet.add_cell(0, i + @start_row, v[1][:name])
      @column_indexs[ v[0] ] = i + @start_row
    end

    @worksheet.change_row_fill(0, '333333') 
    @worksheet.change_row_font_color(0, 'ffffff')    
    
  end

  def generate(url, result)
    @num += 1

    # add service column
    @worksheet.add_cell(@num, 0, url[:url])

    result.each_with_index.map do |v,i|
      column = @column_indexs[ v[:field_id] ]
      field  = @cpfs[ v[:field_id] ]

      case field[:otype]
      when "text"
        value = v[:result_text]
      when "html"
        value = v[:result_text] 
      when "attr"
        value = v[:result_text] 
      when "array"
        value = v[:result_arr].join(', ') 
      when "array_attr"
        value = v[:result_arr].join(', ')
      else
        value = "-" 
      end 


      @worksheet.add_cell(@num, column, value)
      progress = (( @num.to_f / @count ) * 100).to_i
      P.update_progress(@cp[:id], progress)    
  
    end

  end

  def after_generate
    filename = "#{Time.now.to_i}.xlsx"
    @workbook.write("#{@paths[:full_path]}#{filename}")

    {:plugin_file_url =>  "#{@paths[:path]}#{filename}" }
  end

end