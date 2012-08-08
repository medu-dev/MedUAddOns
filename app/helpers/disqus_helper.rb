module DisqusHelper

  DISQUS_TITLE = "disqus_title"
  DISQUS_SHORTNAME = "disqus_shortname"
  DISQUS_DEVELOPER = "disqus_developer"
  DISQUS_DEVELOPER_OFF = "0"
  DISQUS_DEVELOPER_ON = "1"
  DISQUS_IDENTIFIER = "disqus_identifier"
  DISQUS_CATEGORY = "disqus_category_id"
  PRODUCTION_SHORTNAME = "medu"
  TESTING_SHORTNAME = "meduTest"

  SEMI_COLON = ";"

  DISQUS_FUNCTION = "(function() {
  var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
  dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();"

  TEST_COURSE = "0000"
  ERROR_VAR = "var error_disqus_setup = '"
  VISIBLE_ERROR_MSG = "Comments are currently unavailable"
  DIV_ID = "disqus_thread"

  @@supported_courses = [TEST_COURSE]

  def  DisqusHelper.build_variable(name, value)
    var = 'var ' + name + ' = "' + value +'"' + SEMI_COLON
    return var
  end

  def DisqusHelper.get_developer
    value = DISQUS_DEVELOPER_OFF

    if RunTimeEnvironment.is_development? || RunTimeEnvironment.is_test?
      value = DISQUS_DEVELOPER_ON
    end

    var = 'var ' + DISQUS_DEVELOPER + ' = ' + value + SEMI_COLON
  end

  def DisqusHelper.get_shortname
    shortname =   PRODUCTION_SHORTNAME

    if RunTimeEnvironment.is_development? || RunTimeEnvironment.is_test?  || RunTimeEnvironment.is_staging?
         shortname = TESTING_SHORTNAME
    end
    return DisqusHelper.build_variable(DisqusHelper::DISQUS_SHORTNAME, shortname)
  end

  def DisqusHelper.get_function
    return DISQUS_FUNCTION
  end

  def DisqusHelper.is_supported?   (course_id)
    return   @@supported_courses.include? (course_id)
  end

  def DisqusHelper.set_error(msg)
    var = ERROR_VAR  + msg + "';\n"
    var += 'document.getElementById("' + DIV_ID + '").innerHTML="' + VISIBLE_ERROR_MSG + '";'

    return var
  end

end
