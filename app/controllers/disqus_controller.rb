class DisqusController < ApplicationController

   CARD_TITLE_PARAM = "title"
   CARD_IDENTIFIER_PARAM = "identifier"
   CARD_CATEGORY_ID_PARAM = "categoryId"
   COURSE_NUMBER_PARAM = "courseId"

  def getcomments
    var = ""

    if is_course_supported(params)
      begin
        var = get_vars (params)
        var += DisqusHelper.get_function
      rescue   Exception => exception
        error_msg = get_error_msg("getcomments", exception.to_s)
        puts "-----> " + error_msg
        var = DisqusHelper.set_error(error_msg)
      end
    end

    render  js: var
  end

  def get_vars  (params)
    text = DisqusHelper.get_shortname
    text += DisqusHelper.get_developer

    text += get_title (params)
    text += get_identifier (params)
    text += get_category_id (params)

    return text
  end

  def get_title params
    title = params[CARD_TITLE_PARAM]
    if(title !=nil && title.length > 0)
      return DisqusHelper.build_variable(DisqusHelper::DISQUS_TITLE,title )
    else
      raise "No card title"
    end
  end

   def get_identifier params
     identifier = params[CARD_IDENTIFIER_PARAM]
     if(identifier !=nil && identifier.length > 0)
       return DisqusHelper.build_variable(DisqusHelper::DISQUS_IDENTIFIER,identifier )
     else
       raise "No card identifier"
     end
   end

   def get_category_id params
     catgory_id = params[CARD_CATEGORY_ID_PARAM]
     if(catgory_id !=nil && catgory_id.length > 0)
       return DisqusHelper.build_variable(DisqusHelper::DISQUS_CATEGORY,catgory_id )
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

end
