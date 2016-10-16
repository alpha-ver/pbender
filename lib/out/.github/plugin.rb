class OutGithub
      # path /lib/out/github/plugin.rb

  #pa   = plugin_activerecord
  #cp   = current project (hash)
  #cpfs = current project fields (hash)
  def initialize(pa=nil, cp=nil, cpfs=nil)
    if pa.blank?
      raise OutGithubPA
    else
      init_plugin(pa) #!
      init_github
      @cp   = cp
      @cpfs = cpfs
    end
  end

  def self.info
    YAML.load_file("#{Rails.root}/lib/out/github/plugin.yml").deep_symbolize_keys
  end 

  def setting_test(delete=false) # <- c[:success] = true/false
    c = create_or_update('test.txt', 'test')
    if c[:success] && delete
      c = delete('test.txt')
    end
    c
  end

  #cu - current url hash
  #rs - resutls hash
  def push_url(cu, rs) # <- live out
    if @pa.setting['layout'].blank?
      erb_layout = File.open("#{Rails.root}/lib/out/github/layout/jekyll.erb").read
    else
      erb_layout = File.open("#{Rails.root}/lib/out/github/layout/#{@pa.setting['layout']}.erb").read
    end
    time = Time.now

    l=Hash[
      @cpfs.map{|i| 
        [
          i[:name], 
          [i, rs.select{|ii| ii[:field_id] == i[:id]}[0] ]
        ]
      }
    ]

    if !l['image'].blank? && l['image'][0][:setting][:download] == 'true'
      if !l['image'][1].blank? && !l['image'][1][:result_text].blank?
        prefix = "#{Rails.root}/public"
        file = File.read(prefix + l['image'][1][:result_text])
        name = l['image'][1][:result_text].split("/")[-1]
        create("img/#{name}", file)
        image_tag = "<img src=\"/img/#{name}\">"
      else
        image_tag = ''
      end
    elsif !l['image'].blank? && l['image'][0][:setting]['download'] == 'false'
      image_tag = ''
    else
      image_tag = ''
    end
      
    template = Erubis::Eruby.new(erb_layout).result({:l =>l, :time_now => time, :image_tag => image_tag})
    path = "_posts/#{time.strftime('%Y-%m-%d')}-#{time.to_i}.html"
    create(path, template)
  end

  #private
    def init_github 
      @gh = Github.new  basic_auth: "#{setting_field('login')}:#{setting_field('password')}",
                        adapter: :net_http,
                        repo: setting_field('repo')
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

    #Gh methods
    def find(path)
      begin
        find = @gh.repos.contents.find setting_field('login'), setting_field('repo'), path
        {:success => true, :result => find}
      rescue Github::Error::GithubError => e
        {:success => false, :error => e.message, :method => 'find', :http_code => e.http_status_code}
      end
    end

    def create(path, content)
      begin
        c = @gh.repos.contents.create setting_field('login'), setting_field('repo'), path,
          path: path,
          message: "Auto commit, method 'create', #{Time.now()}",
          content: content
        {:success => true, :result => c}
      rescue Github::Error::GithubError => e
        {:success => false, :error => e.message, :method => 'create'}
      end
    end

    def delete(path, f=nil)
      begin
        if f.nil?
          f = find(path)
        end

        if f[:success]
          c = @gh.repos.contents.delete setting_field('login'), setting_field('repo'), path,
            path: path,
            message: "Auto commit, method 'delete', #{Time.now()}",
            sha: f[:result].sha
          {:success => true, :result => c, :method => 'delete'}
        else
          {:success => false, :error => f[:error], :method => f[:method]}
        end
      rescue Github::Error::GithubError => e
        {:success => false, :error => e.message}
      end
    end

    def update(path, content, f=nil)
      begin
        if f.nil?
          f = find(path)
        end
        
        if f[:success]      
          c = @gh.repos.contents.update setting_field('login'), setting_field('repo'), path,
            path: path,
            message: "Auto commit, method 'update', #{Time.now()}",
            content: content,
            sha: f[:result].sha
          {:success => true, :result => c, :method => 'update'}
        else
          {:success => false, :error => f[:error], :method=> f[:method]}
        end
      rescue Github::Error::GithubError => e
        {:success => false, :error => e.message, :method => 'update'}
      end
    end

    def create_or_update(path, content)
      f=find(path)
      if f[:success]
        update(path, content, f)
      elsif !f[:success] && f[:http_code] == 404 
        create(path, content)
      else
        f
      end
    end


end