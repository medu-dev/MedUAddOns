class QuestionLogger  < LoggerBase

  LOGFILE = "questions.log"

  def initialize(log_file_name)
    super(log_file_name)
  end

  def format_error_message(error)
    msg = "Error: " +  DateTime.now.strftime("%Y-%m-%d %H:%M:%S") + " - " + error

    return msg
  end

  def log_error(error)
    create_log_entry(format_error_message(error))
  end

end