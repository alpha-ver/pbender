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

	def open_url(url='')
    old_full_url = @full_url
    @full_url    = @project.url + url

		begin
      html = open(@full_url).read.force_encoding("UTF-8")
			@doc = Nokogiri::HTML(html)
			{:success => true}
		rescue Exception => e
      @full_url = old_full_url
			{:success => false, :error => e.message}
		end
	end

  def get_raw()
    @doc.to_s.force_encoding("UTF-8")
  end

  def get_highlight()
    formatter = Rouge::Formatters::HTML.new
    lexer     = Rouge::Lexers::HTML.new
    formatter.format(lexer.lex(get_raw))
  end

  def get_result_field(field)
    ren = nil
    r   = xpath(field[:setting]['xpath'])
    if r[:success]
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

    def xpath(str)
      begin
        x = @doc.xpath(str)
        {:success => true, :result => x}
      rescue Exception => e
        {:success => false, :error => e.message}
      end
    end
end