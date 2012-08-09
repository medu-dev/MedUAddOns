class DisqusController < ApplicationController

   CARD_TITLE_PARAM = "title"
   CARD_IDENTIFIER_PARAM = "identifier"
   CARD_CATEGORY_ID_PARAM = "categoryId"
   COURSE_NUMBER_PARAM = "courseId"

   COMMENTS_TEMPLATE_PATH = "public/javascript/embedcomments.js"

  def getcomments
    var = ""

    if is_course_supported(params)
      begin
        var  = read_template(COMMENTS_TEMPLATE_PATH)
        get_vars(params, var)
      rescue   Exception => exception
        error_msg = get_error_msg("getcomments", exception.to_s)
        puts "-----> " + error_msg
        var = DisqusHelper.set_error(error_msg)
      end
    end

    render  js: var
  end

  def get_vars  (params, text)
    DisqusHelper.replace_shortname_tag (text)
    DisqusHelper.replace_developer_tag(text)

    get_title(params, text)
    get_identifier(params, text)
    get_category_id(params, text)

    return text
  end

  def get_title params, text
    title = params[CARD_TITLE_PARAM]
    if(title !=nil && title.length > 0)
      return DisqusHelper.replace_tag(text, DisqusHelper::TITLE_TAG,title )
    else
      raise "No card title"
    end
  end

   def get_identifier params, text
     identifier = params[CARD_IDENTIFIER_PARAM]
     if(identifier !=nil && identifier.length > 0)
       return DisqusHelper.replace_tag(text, DisqusHelper::IDENTIFIER_TAG,identifier )
     else
       raise "No card identifier"
     end
   end

   def get_category_id params, text
     catgory_id = params[CARD_CATEGORY_ID_PARAM]
     if(catgory_id !=nil && catgory_id.length > 0)
       return DisqusHelper.replace_tag(text, DisqusHelper::CATEGORY_TAG,catgory_id )
     else
       raise "No category id"
     end
   end

  def get_error_msg method, exception_msg
    msg =  DateTime.now.strftime("%a, %b %d %Y %H:%M:%S ")
    msg +=   "Exception in " + method   + ": "
    msg += exception_msg

    return msg
  end

  def is_course_supported params
    course_id = params[COURSE_NUMBER_PARAM]

    return DisqusHelper.is_supported? (course_id)
  end

  def read_template   path
     template = ""
    begin
      template_file = File.open(path, "r")
      if (template_file == nil)
        raise "Unable to read template: "  + path
      else
        file_size = File.size(path)
        template = template_file.sysread(file_size)
        return template
      end
    rescue   Exception => exception
         raise exception.to_s
    end
  end

end
