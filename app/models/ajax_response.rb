class AjaxResponse

  ERROR = "error"
  SUCCESS = "success"

  def initialize(status, message)
    @status = status
    @message = message
  end

end