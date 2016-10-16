require 'httparty'
require 'open-uri'

class OutHttp
      # path /lib/out/github/plugin.rb

  #pa   = plugin_activerecord
  #cp   = current project (hash)
  #cpfs = current project fields (hash)
  def initialize(pa=nil, cp=nil, cpfs=nil)
    if pa.blank?
      raise OutHttpPA
    else
      @cp   = cp
      @cpfs = cpfs
      @pa   = pa
      @yml  = YAML.load_file("#{Rails.root}/lib/out/http/plugin.yml").deep_symbolize_keys
    end    
  end

  def self.info
    YAML.load_file("#{Rails.root}/lib/out/http/plugin.yml").deep_symbolize_keys
  end 

  def setting_test(delete=false) # <- c[:success] = true/false
    begin
      o = open("#{setting_field('url')}?key=#{setting_field('key')}")
      if o.status[0]
        json = JSON.parse(o.read)
        r json['success'], json['result'] 
      else
        r false
      end
    rescue Exception => e
      r false, e.message
    end
  end

  #url - current url hash
  #result - resutls hash
  def push_url(url, result) # <- live out
    out = {}
    result.each_with_index.map do |v,i|
      field = @cpfs[ v[:field_id] ]

      if !field[:setting].nil? && field[:setting][:download] == "true"
        str = "https://pbender.ru" + v[:result_text]
      else
        str = v[:result_text]
      end

      case field[:otype]
      when "text"
        out[field[:name]] = str
      when "html"
        out[field[:name]] = str
      when "attr"
        out[field[:name]] = str
      when "array"
        out[field[:name]] = v[:result_arr ]
      when "array_attr"
        out[field[:name]] = v[:result_arr ]
      else
        #out << "-" 
      end
    end

    body = false
    begin
      body = HTTParty.post(
        "#{setting_field('url')}", 
        body: {
          key:    setting_field('key'),
          url:    url,
          fields: out
        }
      ).body

      json = JSON.parse(body)
    rescue Exception => e
      puts e.message.colorize(:red)
      if !body
        body = 'Pre initialize HTTParty'
      end
    end

    #dev!
    
    if json.nil?
      puts body.colorize(:red)
    elsif !json.nil? && json['success'] == false
      puts json.to_json.colorize(:yellow)
    elsif !json.nil? && json['success'] == true
      puts json.to_json.colorize(:green)
    else
      puts json.to_json.colorize(:red)
      #не может быть
    end



  end

#for generated metod
  def before_generate(count=nil)
    @count = count
    @num   = 0
  end

  def generate(url, result)
    @num += 1

    sleep 0.3
    push_url(url, result)

    progress = (( @num.to_f / @count ) * 100).to_i
    P.update_progress(@cp[:id], progress)    
  end

  def after_generate
    {:plugin_file_url =>  "none" }
  end

  def setting_field(name)
    if !@pa.setting.blank? && !@pa.setting[name].nil?
      @pa.setting[name]
    end
  end

  private

    def setting_field(name)
      if !@pa.setting.blank? && !@pa.setting[name].nil?
        @pa.setting[name]
      end
    end

    def r success, result=nil
      {:success => success, :result => result}
    end

end