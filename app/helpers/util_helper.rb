module UtilHelper

  # commont parameters
  PARAM_CARDID = "cardid"
  PARAM_USERID = "userid"
  PARAM_QUESTIONID = "questionid"
  PARAM_SCORE = "score"

  # substitution parameters
  SUB_CARDID = "<<CARDID>>"
  SUB_USERID = "<<USERID>>"
  SUB_HOSTNAME = "<<HOSTNAME>>"

  # host names
  LOCALHOST = "localhost:3000"
  STAGING = "cryptic-bastion-5586.herokuapp.com"
  PRODUCTION = "localhost:3000"

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

  def self.get_user_id(params)
    user_id = params[PARAM_USERID]

    if(user_id == nil || user_id.length == 0)
      user_id = UNKNOWN_USER
    end

    return user_id
  end

  def self.replace_hostname(text)
    hostname = get_hostname
    replace_tag(text, SUB_HOSTNAME, hostname)
  end

  def self.get_hostname
    hostname = PRODUCTION

    if(RunTimeEnvironment.is_development? || RunTimeEnvironment.is_test?)
      hostname = LOCALHOST
    else if RunTimeEnvironment.is_staging?
          hostname = STAGING
         end
    end

    return hostname
  end
end
