# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#####################
c=(log, status, m) ->
  m = (if typeof m isnt "undefined" then m * 10 else 10)
  switch status
    when 'success'
      css = " background: #000;
              border-left: #{m}px solid #1A5E25;
              color: #1A5E25;
              padding-left:10px;
              display:block"
    when 'error'
      css = " background: #000;
              border-left: #{m}px solid #B00;
              color: #B00;
              padding-left:10px;
              display:block"

    when 'event'
      css = " background: #000;
              border-left: #{m}px solid #FB1;
              color: #FB1;
              padding-left:10px;
              display:block"
    when 'dev'
      css = ""

    when 'bottom'
      css = " border-bottom: 4px solid #999;
              display:block"

  console.log "%c#{log}", css
################
#funcs

clear_has=(a) ->
  $("#{a}").removeClass('has-warning has-success has-error')
  $("#{a} > label").html('&nbsp;')
#end func

clear_panel=(a) ->
  a.removeClass('panel-warning panel-success panel-danger panel-default panel-info')
  a.children("label").html('&nbsp;')

get_checkbox=(a) ->
  if a && a != 'false'
    "checked=\"checked\""
  else
    ""

get_disabled=(a) ->
  if !a
    "disabled=\"disabled\""
  else
    ""

get_params=(s, h) ->
  if s == null || s == undefined
    ""
  else
    if s[h] == null || s[h] == undefined
      ""
    else
      "#{s[h]}".replace(/"/g, "'")


selectpicker=() -> 
  $('.fieldOption_select').selectpicker ->
    style: 'btn-info'

  $('.OutPlugin_select').selectpicker ->
    style: 'btn-info'

panel_class=(v) ->
  if v['add'] != undefined
    'panel-warning'
  else
    if v['enabled'] == false && v['ok'] == false
      'panel-default'
    else if v['enabled'] == false && v['ok'] == true
      'panel-info'
    else if v['enabled'] == true && v['ok'] == false
      'panel-error'
    else if v['enabled'] == true && v['ok'] == true
      'panel-success'


add_accordion_field=(v) ->
  c "add accordion field #{v['name']}", "event"

  if v['setting']!=null
    dow = get_checkbox(v['setting']['download'])
  else
    dow = ''

  html = [
    "<div class=\"panel #{panel_class(v)}\" id=\"panel_field_#{v['name']}\">",
      "<div class=\"panel-heading\" role=\"tab\" id=\"heading_#{v['name']}\">",
        "<h4 class=\"panel-title\">",
          "<a class=\"collapsed\" role=\"button\" data-toggle=\"collapse\" data-parent=\"#accordion\" href=\"#accordion_field_#{v['name']}\" aria-expanded=\"false\" aria-controls=\"accordion_field_#{v['name']}\">",
            "&nbsp;",
            v['name'],
          "</a>",
        "</h4>",
      "</div>",
      "<div id=\"accordion_field_#{v['name']}\" class=\"panel-collapse collapse\" role=\"tabpanel\" aria-labelledby=\"heading_#{name}\">",
        "<div class=\"panel-body\">",
          "<div class=\"checkbox\">",
            "<label>",
              "<input type=\"checkbox\" name=\"fieldOption_unique_#{v['name']}\" #{get_checkbox(v['unique'])}> Уникальный",
            "</label>",

            "<label>",
              "<input type=\"checkbox\" name=\"fieldOption_required_#{v['name']}\" #{get_checkbox(v['required'])}> Обязательный",
            "</label>"

            "<label>",
              "<input type=\"checkbox\" #{get_disabled(v['ok'])} name=\"fieldOption_enabled_#{v['name']}\" #{get_checkbox(v['enabled'])}> Включить",
            "</label>"
          "</div>",

          "<div class=\"form-group\">", #has-success...
            "<label class=\"control-label\" for=\"input_field_xpath_#{v['name']}\">",
              "&nbsp;",
            "</label>"
            "<div class=\"input-group\">",
              "<span class=\"input-group-addon\">Xpath</span>",
              "<input name=\"fieldOption_xpath_#{v['name']}\" type=\"text\" class=\"form-control\" id=\"input_field_xpath_#{v['name']}\" value=\"#{get_params(v['setting'], 'xpath')}\">",
              "<select class=\"fieldOption_select show-tick\" name=\"fieldOption_otype_#{v['name']}\" data-width=\"95px\">",
                "<optgroup label=\"Строка\">",
                  "<option value=\"text\">Текст</option>",
                  "<option value=\"html\">HTML</option>",
                  "<option value=\"attr\">Атрибут</option>",
                "</optgroup>",
                "<optgroup label=\"Цикл\">",
                  "<option value=\"array\">Массив</option>",
                  "<option value=\"array_attr\">Атрибут</option>",
                "</optgroup>",
              "</select>",
            "</div>",
          "</div>"       
          "<div id=\"fieldInput_attr_#{v['name']}\">",
          "</div>",

          "<div class=\"form-group\">",           
            "<div class=\"input-group\">",
              "<span class=\"input-group-addon\">Регулярка</span>",
              "<input name=\"fieldOption_regex_#{v['name']}\" type=\"text\" class=\"form-control\" id=\"input_field_regex_#{v['name']}\" value=\"#{get_params(v['setting'], 'regex')}\">",
            "</div>",
          "</div>",

          "<div class=\"checkbox\">",
            "<label>",
              "<input type=\"checkbox\" name=\"fieldOption_download_#{v['name']}\" #{dow}> Скачать",
            "</label>",

          "</div>",

            
          "<button type=\"button\" id=\"fieldOption_submit_#{v['name']}\" class=\"btn btn-success fieldOption_submit btn-sm btn-block\">",
            "Сохранить / Проверить",
          "</button>"
          "<button type=\"button\" id=\"fieldOption_delete_#{v['name']}\" class=\"btn btn-danger fieldOption_delete btn-sm btn-block\">",
            "Удалить",
          "</button>"
        "</div>",
      "</div>",
    "</div>"
  ].join("")
  $('#fields-accordion').append(html)
  selectpicker()
  type = get_params(v, 'otype')
  if type != ""
    $("select[name='fieldOption_otype_#{v['name']}']").selectpicker('val', type)
    #DUB @go to
    if type == "attr" || type == "array_attr"
      html = [
        "<div class=\"form-group\">",           
          "<div class=\"input-group\">",
            "<span class=\"input-group-addon\">Атрибут</span>",
            "<input name=\"fieldOption_attr_#{v['name']}\" type=\"text\" class=\"form-control\" id=\"input_field_attr_#{v['name']}\" value=\"#{get_params(v['setting'], 'attr')}\">",
          "</div>",
        "</div>"
      ].join("")
      $("#fieldInput_attr_#{v['name']}").html(html)
    else
      $("#fieldInput_attr_#{v['name']}").html('')
#################################################

$ -> 
  $(document).ready ->
    c 'document_ready', 'event'
    #autoloading AJAX
    if $("#project_def").val() == "edit"
      $('body').addClass('loading')
      $.ajax
        type: "POST"
        url: '/api/get_fields'
        data: $("form.edit_project").serialize()
        success: (xhr) ->
          if xhr['success']
            if xhr['fields'].length !=0
              $.each xhr['fields'], (i,v) ->
                add_accordion_field(v)
            else
              #тут дизайн что нет не хуя
          else
            c "AJAX error /api/get_fields", "error"
            console.log xhr['fields']
          $('body').removeClass('loading')
        error: (xhr) ->
          c "AJAX error #{xhr['status']} /api/get_fields", "error"
          console.log xhr
          alert('Ошибка сервера! :(')
          $('body').removeClass('loading')


    #Settings
    $("input[name='setting\[option_url\]'").change ->
      c "input_option_url_change", 'event'
      switch this['id']
        when 'setting_option_url_recursion'
          $("input[name='setting\[range_str\]']"  ).prop( "disabled", true  );
          $("input[name='setting\[list_str\]']"   ).prop( "disabled", true  );
          $("textarea[name='setting\[list_str\]']").prop( "disabled", true  );
          $("input[name='setting\[include_str\]']").prop( "disabled", false );        
          $("input[name='setting\[exclude_str\]']").prop( "disabled", false );
          $("#recursion_hs").show("fast")
          $("#range_hs").hide("fast")
          $("#list_hs").hide("fast")
        when 'setting_option_url_range'
          $("input[name='setting\[include_str\]']").prop( "disabled", true  );       
          $("input[name='setting\[exclude_str\]']").prop( "disabled", true  );
          $("textarea[name='setting\[list_str\]']").prop( "disabled", true  );
          $("input[name='setting\[range_str\]']"  ).prop( "disabled", false );  
          $("#recursion_hs").hide("fast")
          $("#range_hs").show("fast")
          $("#list_hs").hide("fast")          
        when 'setting_option_url_list'
          $("input[name='setting\[range_str\]']"  ).prop( "disabled", true  );
          $("input[name='setting\[include_str\]']").prop( "disabled", true  );       
          $("input[name='setting\[exclude_str\]']").prop( "disabled", true  );
          $("textarea[name='setting\[list_str\]']").prop( "disabled", false );
          $("#recursion_hs").hide("fast")
          $("#range_hs").hide("fast")
          $("#list_hs").show("fast")

    #p
    #url change
    $(".p_url_change").on 'click', (event) ->
      event.preventDefault();
      url    = $("#project_current_url").val()
      newurl = this.hash.replace("#", "")
      if url != newurl
        c "🔗 #{this['hash']}", "event"
        $("#project_current_url").val(newurl)
        $("h1.title_current_url > small > span").html(newurl)
        $("a.p_url_change[href='##{url}']").parent().removeClass('active')
        $(this).parent().addClass('active')
        ####ajax
        $('body').addClass('loading')
        $.ajax
          type: "POST"
          url: '/api/get_html'
          data: 
            utf8: "✓"
            authenticity_token: $("input[name='authenticity_token']").val()
            project: 
              id: $("input[name='project\[id\]']").val()
            current_url: $("input[name='project\[current_url\]']").val()
          success: (xhr) ->
            if xhr['success']
              $("#t-code").html(xhr['result_highlight'])
            else
              $("#t-code").html([
                "<div class=\"alert alert-danger\" role=\"alert\">",
                  xhr['error'],
                "</div>"
              ].join(''))
            $('body').removeClass('loading')
          error: (xhr) ->
            $("#t-code").html([
              "<div class=\"alert alert-danger\" role=\"alert\">",
                "Ошибка сервера",
              "</div>"
            ].join(''))
            c "AJAX error #{xhr['status']} /api/get_html", "error"
            console.log xhr
            $('body').removeClass('loading')


    #add field
    $(".p_field_add").on 'click', (event) -> 
      c "+ add_field", "event"
      name = $("input[name='field_add']").val()
      clear_has('.url_add_group')

      if name == ""
        $('.p_url_add_group').addClass('has-warning')
        $('.p_url_add_group > label').html('Имя поля не может быть пустым')
      else
        $('body').addClass('loading')
        $.ajax
          type: "POST"
          url: '/api/add_field'
          data: $("form.edit_project").serialize()
          success: (xhr) ->
            if xhr['success']
              $('.p_url_add_group').addClass('has-success')
              $('.p_url_add_group > label').html(xhr['message'])
              #add accordion
              add_accordion_field(
                name:    xhr['params']['field_add'], 
                add:     true )
            else
              $('.p_url_add_group').addClass('has-error')
              $('.p_url_add_group > label').html(xhr['message'])
            $('body').removeClass('loading')
          error: (xhr) -> 
            $('.p_url_add_group').addClass('has-error')
            $('.p_url_add_group > label').html('Ошибка сервера.')
            c "AJAX error #{xhr['status']} /api/add_post", "error"
            console.log xhr
            $('body').removeClass('loading')


    #focus clear has
    $("input[name='p_field_add']").on 'focus', (event) ->
      c 'Focus p_field_add', 'event'
      clear_has('.p_url_add_group')


    $(document.body).delegate "#fields-accordion input[type='text']" ,'focus', (event) ->
      c "Focus_field #{this.name}", 'event'
      fg = $("input[name='#{this.name}']").parent().parent()
      fg.removeClass('has-warning has-success has-error')
      fg.children('label').html('&nbsp;')



    #select
    $(document.body).delegate 'select.fieldOption_select', 'changed.bs.select', (event) ->
      c "Select fieldOption #{this.name}", 'event'
      name  = this.name.split("_")[2] 
      value = $("select[name='#{this.name}']").find(":selected").val()
      if value == "attr" || value == "array_attr"
        html = [
          "<div class=\"form-group\">",           
            "<div class=\"input-group\">",
              "<span class=\"input-group-addon\">Атрибут</span>",
              "<input name=\"fieldOption_attr_#{name}\" type=\"text\" class=\"form-control\" id=\"input_field_attr_#{name}\">",
            "</div>",
          "</div>"
        ].join("")
        $("#fieldInput_attr_#{name}").html(html)
      else
        $("#fieldInput_attr_#{name}").html('')

    #Save field fieldOption_submit
    $(document.body).delegate 'button.fieldOption_submit', 'click', (event) ->
      c "fieldOption_submit #{this.id}", "event"
      $('body').addClass('loading')
      name = this.id.split("_")[2]
      ######
      $.ajax
        type: "POST"
        url: '/api/edit_field'
        data: 
          utf8: "✓"
          authenticity_token: $("input[name='authenticity_token']").val()
          project: 
            id: $("input[name='project\[id\]']").val()
          current_url: $("input[name='project\[current_url\]']").val() 
          field:
            name: name
            setting:     
              xpath:    $("input[name='fieldOption_xpath_#{name}']").val()
              attr:     $("input[name='fieldOption_attr_#{name}']").val()
              regex:    $("input[name='fieldOption_regex_#{name}']").val()
              download: $("input[name='fieldOption_download_#{name}']").prop('checked')
            otype:    $("select[name='fieldOption_otype_#{name}']").find(":selected").val()
            unique:   $("input[name='fieldOption_unique_#{name}']").prop('checked')
            required: $("input[name='fieldOption_required_#{name}']").prop('checked')
            enabled:  $("input[name='fieldOption_enabled_#{name}']").prop('checked')

        success: (xhr) ->
          clear_panel($("#panel_field_#{name}"))
          clear_has("#panel_field_#{name} .form-group")
          if xhr['success']
            $("#panel_field_#{name}").addClass('panel-success')
            $("#panel_field_#{name} .form-group").addClass('has-success')
            $("input[name='fieldOption_enabled_#{name}']").prop("disabled", false)

            switch xhr['field']['otype'] 
              when "html"
                html = "<h3>HTML</h3>#{xhr['result_highlight']}"
              when 'text'
                html = "<h3>Текст</h3><p>#{xhr['result']}</p>"
              when 'array' 
                html = "<h3>Массив</h3><ol>"
                $.each xhr['result'], (i,v) ->
                  html += "<li>#{v}</li>"
                html += "</ol>"
              when 'attr'
                html = "<h3>Атрибут</h3><p>#{xhr['result']}</p>"
              when 'array_attr'
                html = "<h3>Массив атрибутов</h3><ol>"
                $.each xhr['result'], (i,v) ->
                  html += "<li>#{v}</li>"
                html += "</ol>"


            $("#t-result").html(html)
            $('#p_tabs a[href="#t-result"]').tab('show')

          else
            $("#panel_field_#{name}").addClass('panel-danger')
            $("#panel_field_#{name} .form-group").addClass('has-error')
            $("#panel_field_#{name} label.control-label").html(xhr['error'])  

          $('body').removeClass('loading')
        error: (xhr) ->
          clear_panel($("#panel_field_#{name}"))
          clear_has("#panel_field_#{name} .form-group")
          $("#panel_field_#{name}").addClass('panel-danger')
          $("#panel_field_#{name} .form-group").addClass('has-error')
          $("#panel_field_#{name} label.control-label").html('Ошибка сервера.')
          c "AJAX error #{xhr['status']} /api/edit_field", "error"
          console.log xhr
          $('body').removeClass('loading')

  
    #Save field fieldOption_submit
    $(document.body).delegate 'button.fieldOption_delete', 'click', (event) ->
      c "fieldOption_delete #{this.id}", "event"
      $('body').addClass('loading')
      name = this.id.split("_")[2]
      ######
      $.ajax
        type: "POST"
        url: '/api/delete_field'
        data: 
          utf8: "✓"
          _method: "delete"
          authenticity_token: $("input[name='authenticity_token']").val()
          project: 
            id: $("input[name='project\[id\]']").val()
            step: $("input[name='project\[step\]']").val()
          current_url: $("input[name='project\[current_url\]']").val() 
          field:
            name: name
        success: (xhr) ->
          if xhr['success']
            $("#panel_field_#{name}").remove()
          else
            clear_panel($("#panel_field_#{name}"))
            clear_has("#panel_field_#{name} .form-group")
            $("#panel_field_#{name}").addClass('panel-danger')
            $("#panel_field_#{name} label.control-label").html('Ошибка Удаления.')
          $('body').removeClass('loading')
        error: (xhr) -> 
          #todo
          clear_panel($("#panel_field_#{name}"))
          clear_has("#panel_field_#{name} .form-group")
          $("#panel_field_#{name}").addClass('panel-danger')
          $("#panel_field_#{name} label.control-label").html('Ошибка сервера.')
          c "AJAX error #{xhr['status']} /api/edit_field", "error"
          console.log xhr
          $('body').removeClass('loading')

    #Save/Update setting
    $(document.body).delegate 'button#ButtonSetting', 'click', (event) ->
      c "Button submit #{this.id}", "event"
      $('body').addClass('loading')
      name = this.id.split("_")[2]
      ######
      $.ajax
        type: "POST"
        url: '/api/upd_project_setting'
        data: 
          utf8: "✓"
          _method: "post"
          authenticity_token: $("input[name='authenticity_token']").val()
          project:
            id:   $("input[name='project\[id\]']").val()
            setting:
              option_url:      $("input[name='setting\[option_url\]']" ).val()
              include_str:     $("input[name='setting\[include_str\]']").val()
              exclude_str:     $("input[name='setting\[exclude_str\]']").val()
              range_str:       $("input[name='setting\[range_str\]']"  ).val()
              list_str:        $("input[name='setting\[list_str\]']"   ).val()
              only_path:       $("input[name='setting\[only_path\]']"   ).is( ":checked" )
              only_path_field: $("input[name='setting\[only_path_field\]']").val()
              plugin:
                id: $("select.OutPlugin_select").find(":selected").val()


        success: (xhr) ->
          clear_panel($("#PanelSettingOut"))         
          if xhr['success']
            $("#PanelSettingOut").addClass('panel-success')
            $("#PanelSettingOut > .panel-heading").html('<span class="glyphicon glyphicon-exclamation-sign"></span> Настройки успешно сохранены.')
          else
            $("#PanelSettingOut").addClass('panel-error')
            $("#PanelSettingOut > .panel-heading").html("<span class=\"glyphicon glyphicon-exclamation-sign\"></span> #{xhr['error']}")
          $('body').removeClass('loading')
        error: (xhr) -> 
          $("#PanelSettingOut").addClass('panel-danger')
          $("#PanelSettingOut > .panel-heading").html('<span class="glyphicon glyphicon-exclamation-sign"></span> Ошибка сервера')
          c "AJAX error #{xhr['status']} /api/upd_project_setting", "error"
          console.log xhr
          $('body').removeClass('loading')

    $("input#setting_only_path_field").change ->
      c "event only_path_field", "event"
      if $("input#setting_only_path_field").val() == ""
        $('#CbOnlyPath b').html("главной")
      else
        $('#CbOnlyPath b').html( $("input#setting_only_path_field").val() )

    #Controll task
    $(document.body).delegate '.controll_task > button', 'click', (event) ->
      c "Button submit #{this.id}", "event"
      $('body').addClass('loading')
      bt = this.id.split("_")

      ######
      $.ajax
        type: "POST"
        url: '/api/controll_task'
        data: 
          utf8: "✓"
          _method: "post"
          authenticity_token: $("input[name='authenticity_token']").val()
          project:
            id: bt[1]
            status: bt[0] 
        success: (xhr) ->
          clear_panel($("#PanelSettingOut"))         
          $('body').removeClass('loading')
        error: (xhr) -> 
          c "AJAX error #{xhr['status']} /api/controll_task", "error"
          console.log xhr
          $('body').removeClass('loading')
