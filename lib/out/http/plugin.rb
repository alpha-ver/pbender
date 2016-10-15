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
      init_plugin(pa) #!
      @cp   = cp
      @cpfs = cpfs
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
        r json['success']
      else
        r false
      end
    rescue Exception => e
      r false, e.message
    end
  end

  #cu - current url hash
  #rs - resutls hash

  def push_url(cu, rs) # <- live out
    time = Time.now

    l=Hash[
      @cpfs.map{|i| 
        [
          i[:name], 
          [i, rs.select{|ii| ii[:field_id] == i[:id]}[0] ]
        ]
      }
    ]

    body = HTTParty.post(
      "#{setting_field('url')}", 
      body: {
        key: setting_field('key'),
        data: l,
        time: time
      }
    ).body

    #result parse
    json = JSON.parse(body)

    if json['success'] == false
      
    else

    end

  end

#for generated metod
  def before_generate(count=nil)
    @count = count
    @num   = 0


  end

  def generate(url, result)
    @num += 1

    out = []

    result.each_with_index.map do |v,i|
      field = @cpfs[ v[:field_id] ]

      case field[:otype]
      when "text"

        out << {:field => field, :result => v[:result_text]  }
      when "html"
        out << {:field => field, :result => v[:result_text]  }
      when "attr"
        out << {:field => field, :result => v[:result_text]  }
      when "array"
        out << {:field => field, :result => v[:result_arr]  }
      when "array_attr"
        out << {:field => field, :result => v[:result_arr]  }
      else
        #out << "-" 
      end 

    end

    body = HTTParty.post(
      "#{setting_field('url')}", 
      body: {
        key: setting_field('key'),
        url: url,
        out: out
      }
    ).body


    progress = (( @num.to_f / @count ) * 100).to_i
    P.update_progress(@cp[:id], progress)    
  end

  def after_generate
    {}
  end

  def setting_field(name)
    if !@pa.setting.blank? && !@pa.setting[name].nil?
      @pa.setting[name]
    end
  end

  private
    def init_github 

    end

    def init_plugin(pa)
      @pa  = pa
      @yml = plugin_conf
    end    

    def plugin_conf
      YAML.load_file("#{Rails.root}/lib/out/github/plugin.yml").deep_symbolize_keys
    end

    def setting_field(name)
      if !@pa.setting.blank? && !@pa.setting[name].nil?
        @pa.setting[name]
      end
    end

    def r success, result=nil
      {:success => success, :result => result}
    end

end