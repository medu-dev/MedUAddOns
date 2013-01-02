module UtilHelper

  # commont parameters
  PARAM_CARDID = "cardid"
  PARAM_USERID = "userid"
  PARAM_QUESTIONID = "questionid"
  PARAM_SCORE = "score"

  # substitution parameters
  SUB_CARDID = "<<CARDID>>"
  SUB_USERID = "<<USERID>>"

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

end
