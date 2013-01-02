require 'test_helper'

class QuestionLoggerTest < ActionView::TestCase

  TEST_LOGFILE = "q_test.log"
  @current_test_file = nil

  def setup


  end

  def teardown
     if(@current_test_file != nil)
       File.delete(@current_test_file)
     end
  end

  def test_open

    logger = QuestionLogger.new(TEST_LOGFILE)
    @current_test_file = logger.get_name

    logfile = logger.open
    assert_equal(true, File.exist?(@current_test_file))

  end

  def test_error_msg

    error_msg = "error message"

    logger = QuestionLogger.new(TEST_LOGFILE)
    @current_test_file = logger.get_name

    logger.log_error(error_msg)

    assert_equal(true, File.exist?(@current_test_file))

    msg = File.open(@current_test_file, "r").read
    assert_equal(true, msg.include?(error_msg))
    assert_equal(true, msg.include?("Error:"))


  end


end