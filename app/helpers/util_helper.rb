module UtilHelper

  # commont parameters
  PARAM_CARDID = "cardid"
  PARAM_USERID = "userid"
  PARAM_COURSEID = "courseid"
  PARAM_QUESTIONID = "questionid"
  PARAM_SCORE = "score"
  PARAM_CASENAME = "casename"
  PARAM_CASEID = "caseid"
  PARAM_CARDNAME = "cardname"
  PARAM_GROUPID = "groupid"

  # substitution parameters
  SUB_CARDID = "<<CARDID>>"
  SUB_USERID = "<<USERID>>"
  SUB_COURSEID = "<<COURSEID>>"
  SUB_HOSTNAME = "<<HOSTNAME>>"
  SUB_CASENAME = "<<CASENAME>>"
  SUB_CASEID = "<<CASEID>>"
  SUB_CARDNAME = "<<CARDNAME>>"
  SUB_GROUPID = "<<GROUPID>>"

  # host names
  LOCALHOST = "localhost:3000"
  STAGING = "cryptic-bastion-5586.herokuapp.com"
  PRODUCTION = "immense-journey-3270.herokuapp.com"

  UNKNOWN_USER ="unknown"

  def self.read_template   path
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

  def self.is_card_supported params
    card_id = params[PARAM_CARDID]

    if(card_id == nil || card_id.length == 0)
      return false
    end

    found = QuestionCard.find_by_card_id(card_id.to_i)

    return found != nil
  end

  def self.replace_tag(str, tag, value)
    return str.gsub!(tag, value)
  end

  def self.replace_card_id_tag(text, card_id)
    replace_tag(text, SUB_CARDID, card_id)
  end

  def self.replace_user_id_tag(text, user_id)
    replace_tag(text, SUB_USERID, user_id)
  end

  def self.replace_course_id_tag(text, card_id)
    replace_tag(text, SUB_COURSEID, card_id)
  end

  def self.get_user_id(params)
    user_id = params[PARAM_USERID]

    if(user_id == nil || user_id.length == 0)
      user_id = UNKNOWN_USER
    end

    return user_id
  end

  def self.replace_case_name_tag(text, case_name)
    replace_tag(text, SUB_CASENAME, case_name)
  end

  def self.replace_case_id_tag(text, case_id)
    replace_tag(text, SUB_CASEID, case_id)
  end

  def self.replace_card_name_tag(text, card_name)
    replace_tag(text, SUB_CARDNAME, card_name)
  end

  def self.replace_group_id_tag(text, group_id)
    replace_tag(text, SUB_GROUPID, group_id)
  end

  def self.replace_hostname(text)
    hostname = get_hostname
    replace_tag(text, SUB_HOSTNAME, hostname)
  end

  def self.replace_quote(text)
    return text.gsub(/"/, "")
  end

  def self.get_hostname
    hostname = PRODUCTION

    if(RunTimeEnvironment.is_development? || RunTimeEnvironment.is_test?)
      hostname = LOCALHOST
      #hostname = "192.168.10.162:3000"
    else if RunTimeEnvironment.is_staging?
          hostname = STAGING
         end
    end

    return hostname
  end
end
