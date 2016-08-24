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
	end

	def open_url(url='/')
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
    urls = @doc.xpath("//a").map{|i| i.attr('href')}.uniq.compact
    urls.delete('/')
    u    = []
    begin
      urls.each do |url|
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

    p @path_url
    
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
        ren=r[:result].map{|i| i.text}.compact
      when 'array_attr'
        ren=r[:result].map{|i| i.attr(field[:setting]['attr'])}.compact
      end
      {:success => true, :result => ren, :result_highlight => reh}
    else
      {:success => false, :error => r[:error]}
    end
  end


  def save_img
  
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
end