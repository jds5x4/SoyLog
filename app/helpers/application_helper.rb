module ApplicationHelper

  def icon_size 
    'icon-2x'  
  end

  def is_uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

  def button_class_lookup(action)
    btn_size = ''

    case action
    when :index
      "btn  #{btn_size}"
    when :show
      "btn btn-success  #{btn_size}"
    when :new
      "btn btn-info  #{btn_size}"
    when :edit
      "btn btn-warning  #{btn_size}"
    when :clone
      "btn btn-success #{btn_size}"
    when :destroy
      "btn btn-danger  #{btn_size}"
    when :flag
      "btn btn-primary #{btn_size}"
    when :info
      "btn btn-inverse #{btn_size}"
    end
  end
  def icon_class_lookup(action)
    case action
    when :index
      'icon-chevron-left'
    when :show
      'icon-info-sign'
    when :new
      'icon-plus'
    when :edit
      'icon-wrench'
    when :clone
      'icon-beaker'
    when :destroy
      'icon-trash'
    when :flag
      'icon-flag'
    when :info
      'icon-question-sign'
    end
  end

  def percent_rda_to_status(percent)

    if Numeric >= percent.class
      percent_diff = (percent-100).abs
      if (percent_diff < 1)
        :success
      elsif percent_diff > 10
        :error
      else
        :warning
      end
    else
      :info
    end

  end

  def get_host_without_www(url)
    begin
      uri = URI.parse(url)
      uri = URI.parse("http://#{url}") if uri.scheme.nil?
      host = uri.host.downcase
      host.start_with?('www.') ? host[4..-1] : host
    rescue
      "Invalid url"
    end
  end

  def h_link(object)
    return link_to object.identify, object
  end
  
  def apply_chain_link_or_print(functions, object)
    # debugger
    
    e = recusive_function_chainer(functions, object)

    # puts "e: #{e}"
    # puts "functions: #{functions}"
    # puts "object: #{object}"

    if functions == [:identify]
      return e
    end

    if e.nil?
      return nil
    elsif String >= e.class
      return e
    elsif Numeric >= e.class
      return e
    elsif (TrueClass >= e.class) || (FalseClass >= e.class)
      return e
    elsif Array >= e.class
      if e.empty?
        return "none"
      end

      e.map{|ee| 
        if ee.nil?
          "nil"
        else
          ee
        end
      }

    else
      begin
        return e
      rescue 
        return "Cold not create a field for #{e.to_s}"
      end
    end
  end

  def recusive_function_chainer(chain, element)
    # puts "recusive_function_chainer: #{chain.inspect}, #{element}"

    e = element

    # for every operation in the chain
    [*chain].each do |link|
      if e.kind_of? Array
        puts "e is array"
        e = e.map{|ee| recusive_function_chainer(link, ee)}
      else
        if link == :identify
          return e
        else
          e = e.try(link)
        end
      end
    end

    return e
  end

  def link_to_add_fields(name, f, association)
    # puts "link_to_add_fields( #{name}, #{f}, #{association.inspect}"

    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      field_to_render = association.to_s.singularize + "_fields"
      # puts "FIELD TO RENDER: #{field_to_render}"
      render(field_to_render, f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  # def current_user
  #   @current_user ||= user_from_remember_token
  # end
end
