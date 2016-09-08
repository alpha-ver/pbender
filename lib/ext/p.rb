class P
	def initialize(h={})
		if h[:user].nil?
			@user=current_user
		else
			@user=h[:user]
		end

	 	if h[:project].nil?
	 		raise ArgumentError, 'Argument :project is not nil'   
		end

		@project  = h[:project] 
    @full_url = nil
		@doc      = nil
    @site_name = 'http://pbender.ru'
	end

	def open_url(url='/')
    print url
    old_full_url = @full_url
    @path_url = url
    @full_url = @project.url + url

		begin
      html = open(@full_url).read
      
			@doc = Nokogiri::HTML(html)
			{:success => true}
		rescue Exception => e
      @full_url = old_full_url
			{:success => false, :error => e.message}
		end
	end

  def get_url
    @path_url
  end

  def get_urls
    begin
      urls = @doc.xpath("//a").map{|i| i.attr('href')}.uniq.compact
      urls.delete('/')
      u    = []
    
      urls.each do |url|
        #fo lo urls
        url.gsub!(/([\s]+)/, '')
        
        uri = URI.parse(url)
        if !uri.path.nil?
          if  uri.host.nil? &&  uri.path[0] == "/"
            if uri.query.nil? 
              u << uri.path
            else
              u << uri.path + "?" + uri.query  
            end
          elsif uri.host.nil? && uri.path[0] != "/"
            if uri.query.nil? 
              u << URI.parse(@full_url).path + uri.path
            else
              u << URI.parse(@full_url).path + uri.path + "?" + uri.query  
            end
          elsif uri.host == URI.parse(@project.url).host
            if uri.query.nil? 
              u << uri.path
            else
              u << uri.path + "?" + uri.query  
            end         
          end
        end
      end
      {:success => true, :result => u.uniq.compact}
    rescue Exception => e
      {:success => false, :error => e.message}
    end
  end

  def get_urls_recursive
    if !@project.setting.blank? && @project.setting['option_url'] == 'recursion'
      urls = get_urls
      if !@project.setting['include_str'].blank?
        is   = @project.setting['include_str']
        urls = urls[:result].map{|i| i.match(is) ? i : nil }.compact
      end

      if !@project.setting['exclude_str'].blank?
        es   = @project.setting['exclude_str']
        urls = urls[:result].map{|i| i.match(ex) ? i : nil }.compact
      end
      {:success => true, :result => urls}
    else
      {:success => false,:error => ""}
    end
  end

  def url_skip?
    i = false
    e = false
    
    if !@project.setting['include_str'].blank?
      i = @path_url.match(@project.setting['include_str']).nil?
    end

    if !@project.setting['exclude_str'].blank?
      e = !@path_url.match(@project.setting['exclude_str']).nil?
    end
    
    i || e
  end

  def get_sha()
     Digest::SHA1.hexdigest @doc.to_s.force_encoding("UTF-8")
  end

  def get_raw()
    @doc.to_s
  end

  def get_highlight()
    formatter = Rouge::Formatters::HTML.new
    lexer     = Rouge::Lexers::HTML.new
    formatter.format(lexer.lex(get_raw))
  end

  def get_result_field(field)
    ren = nil
    r   = xpath(field[:setting]['xpath'])
    if r[:success] && !r[:result].blank?
      formatter = Rouge::Formatters::HTML.new
      lexer     = Rouge::Lexers::HTML.new
      reh       = nil
      ####
      case field['otype']
      when 'text'
        ren=r[:result].text
      when 'html'
        ren=r[:result].to_s
        reh=formatter.format(lexer.lex(ren))
      when 'attr'
        ren=r[:result].attr(field[:setting]['attr']).to_s
      when 'array'
        ren=r[:result].map{|i| i.text}.compact.uniq
      when 'array_attr'
        ren=r[:result].map{|i| i.attr(field[:setting]['attr'])}.compact.uniq
      end

      #regex 
      if !field[:setting]['regex'].blank?
        regex = %r[#{field[:setting]['regex']}]i

        if ren.class == Array
          ren = ren.map{|i|
            if !regex.match(i).nil?
              # only first math
              regex.match(i)[1]
            end
          }.compact
        
        else ren.class == String
          if !regex.match(ren).nil?
            # only first math
            ren = regex.match(ren)[1]
          end
        end
      end

      #save file
      ren = save_file(field, ren)
      {:success => true, :result => ren, :result_highlight => reh, :downloads => field[:setting]['download']}
    else
      {:success => false, :error => r[:error]}
    end
  end

  private

    def xpath(str)
      begin
        x = @doc.xpath(str)
        {:success => true, :result => x}
      rescue Exception => e
        {:success => false, :error => e.message}
      end
    end

    def save_file(field, link)
      if field[:setting]['download'] == 'true'
        if link.class == Array
          new_link = []
          link.each do |i|
            new_link << safe_open(i)
          end
        elsif link.class == String
          new_link = safe_open(link)
        end
        new_link
      else
        link
      end
    end

    def safe_open(path)
      begin

        uri = URI.parse(path)

        if path[0] == "/"
          url = @project.url + path
        else
          url = path
        end
        f = open(url).read
        path = dir_create + Digest::MD5.hexdigest(f) + '.' + uri.path.split('.')[-1]
        File.open(path, 'wb'){|sf| sf.write(f)}
        f = nil
        path
      rescue Exception => e
        e.message
      end
    end

    def dir_create 
      #@todo код говно
      prefix = "#{Rails.root}/public/pf/"
      us = @user.id.to_s
      ps = @project.id.to_s
      if !Dir.exist?(prefix + us)
        Dir.mkdir(prefix + us)
      end
      
      if !Dir.exist?(prefix + us + '/' + ps)
        Dir.mkdir(prefix + us + '/' + ps)
      end

      prefix + us + '/' + ps  + '/'
    end


end