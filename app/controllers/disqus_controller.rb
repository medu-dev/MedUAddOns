class DisqusController < ApplicationController

   CARD_TITLE_PARAM = "title"
   CARD_IDENTIFIER_PARAM = "identifier"
   CARD_CATEGORY_ID_PARAM = "categoryId"

  def getcomments
    var = ""
    begin
      var = get_vars (params)
      var += DisqusHelper.get_function
    rescue   Exception => exception
      puts "---- Exception: get_embedded_comments: " + exception.to_s
    end

    render  text: var
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

end
