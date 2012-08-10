module DisqusHelper

  PRODUCTION_SHORTNAME = "medu"
  TESTING_SHORTNAME = "meduTest"

  DISQUS_DEVELOPER_OFF = "0"
  DISQUS_DEVELOPER_ON = "1"

  TEST_COURSE = "0000"
  ERROR_VAR = "var error_disqus_setup = '"
  VISIBLE_ERROR_MSG = "Comments are currently unavailable"
  DIV_ID = "disqus_thread"

  SHORTNAME_TAG = "<PMW shortname>"
  DEVELOPER_TAG = "<PMW developer>"
  TITLE_TAG = "<PMW cardname>"
  IDENTIFIER_TAG = "<PMW cardid>"
  CATEGORY_TAG = "<PMW casename>"

  @@supported_courses ={   "3420" => "medu-clipp",
                                                TEST_COURSE =>  TESTING_SHORTNAME
                                            }

  def DisqusHelper.replace_tag(str, tag, value)
    return str.gsub!(tag, value)
  end

  def DisqusHelper.replace_developer_tag  text
    value = DISQUS_DEVELOPER_OFF

    if RunTimeEnvironment.is_development? || RunTimeEnvironment.is_test?
      value = DISQUS_DEVELOPER_ON
    end

    replace_tag(text, DEVELOPER_TAG, value)
  end

  def DisqusHelper.replace_shortname_tag(text, courseid)
    shortname =   @@supported_courses[courseid]

    replace_tag(text, SHORTNAME_TAG, shortname)
  end


  def DisqusHelper.is_supported?   (course_id)
    return   @@supported_courses.include? (course_id)
  end

  def DisqusHelper.set_error(msg)
    var = ERROR_VAR  + msg + "';\n"
    var += 'document.getElementById("' + DIV_ID + '").innerHTML="' + VISIBLE_ERROR_MSG + '";'

    return var
  end

  def DisqusHelper.get_shortname(courseid)
      return  @@supported_courses[courseid]
  end

end
