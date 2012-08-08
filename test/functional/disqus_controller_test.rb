require 'test_helper'

class DisqusControllerTest < ActionController::TestCase

  CARD_TITLE = "test title"
  CARD_IDENTIFIER = "test_identifier_1"
  CARD_CATEGORY_ID = "test_category_id"

  def setup
    @controller = DisqusController.new
  end

  def test_build_javascript
    env = Rack::MockRequest.env_for("/",:params => {DisqusController::CARD_TITLE_PARAM =>CARD_TITLE,
                                                                                        DisqusController::CARD_IDENTIFIER_PARAM =>CARD_IDENTIFIER,
                                                                                        DisqusController::CARD_CATEGORY_ID_PARAM =>CARD_CATEGORY_ID,
                                                                                        DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE})

    endpoint = DisqusController.action(:getcomments)

    body = endpoint.call(env)
    text = body[2].body

    assert_equal( true, text.include?(DisqusHelper::DISQUS_SHORTNAME))
    assert_equal( true, text.include?(DisqusHelper::PRODUCTION_SHORTNAME))

    assert_equal( true, text.include?(DisqusHelper::DISQUS_DEVELOPER))
    assert_equal( true, text.include?(DisqusHelper::DISQUS_DEVELOPER_ON))

    assert_equal( true, text.include?(DisqusHelper::DISQUS_TITLE))
    assert_equal( true, text.include?(CARD_TITLE))

    assert_equal( true, text.include?(DisqusHelper::DISQUS_IDENTIFIER))
    assert_equal( true, text.include?(CARD_IDENTIFIER))

    assert_equal( true, text.include?(DisqusHelper::DISQUS_CATEGORY))
    assert_equal( true, text.include?(CARD_CATEGORY_ID))

    assert_equal( true, text.include?(DisqusHelper::DISQUS_FUNCTION))

  end

  def test_nil_title
    env = Rack::MockRequest.env_for("/",:params => {DisqusController::CARD_TITLE_PARAM =>nil,
                                                    DisqusController::CARD_IDENTIFIER_PARAM =>CARD_IDENTIFIER,
                                                    DisqusController::CARD_CATEGORY_ID_PARAM =>CARD_CATEGORY_ID,
                                                    DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE})

    endpoint = DisqusController.action(:getcomments)

    body = endpoint.call(env)
    text = body[2].body

    assert_equal(true, check_error_var(text))

  end

  def test_no_title
    env = Rack::MockRequest.env_for("/",:params => {DisqusController::CARD_TITLE_PARAM =>"",
                                                    DisqusController::CARD_IDENTIFIER_PARAM =>CARD_IDENTIFIER,
                                                    DisqusController::CARD_CATEGORY_ID_PARAM =>CARD_CATEGORY_ID,
                                                    DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE})

    endpoint = DisqusController.action(:getcomments)

    body = endpoint.call(env)
    text = body[2].body

    assert_equal(true, check_error_var(text))

  end

  def test_nil_identifier
    env = Rack::MockRequest.env_for("/",:params => {DisqusController::CARD_TITLE_PARAM =>CARD_TITLE,
                                                    DisqusController::CARD_IDENTIFIER_PARAM =>nil,
                                                    DisqusController::CARD_CATEGORY_ID_PARAM =>CARD_CATEGORY_ID,
                                                    DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE})

    endpoint = DisqusController.action(:getcomments)

    body = endpoint.call(env)
    text = body[2].body

    assert_equal(true, check_error_var(text))

  end

  def test_no_identifier
    env = Rack::MockRequest.env_for("/",:params => {DisqusController::CARD_TITLE_PARAM =>CARD_TITLE,
                                                    DisqusController::CARD_IDENTIFIER_PARAM =>"",
                                                    DisqusController::CARD_CATEGORY_ID_PARAM =>CARD_CATEGORY_ID,
                                                    DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE})

    endpoint = DisqusController.action(:getcomments)

    body = endpoint.call(env)
    text = body[2].body

    assert_equal(true, check_error_var(text))

  end

  def test_nil_category_id
    env = Rack::MockRequest.env_for("/",:params => {DisqusController::CARD_TITLE_PARAM =>CARD_TITLE,
                                                    DisqusController::CARD_IDENTIFIER_PARAM =>CARD_IDENTIFIER,
                                                    DisqusController::CARD_CATEGORY_ID_PARAM =>nil,
                                                    DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE})

    endpoint = DisqusController.action(:getcomments)

    body = endpoint.call(env)
    text = body[2].body

    assert_equal(true, check_error_var(text))

  end

  def test_no_category_id
    env = Rack::MockRequest.env_for("/",:params => {DisqusController::CARD_TITLE_PARAM =>CARD_TITLE,
                                                    DisqusController::CARD_IDENTIFIER_PARAM =>CARD_IDENTIFIER,
                                                    DisqusController::CARD_CATEGORY_ID_PARAM =>"",
                                                    DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE})

    endpoint = DisqusController.action(:getcomments)

    body = endpoint.call(env)
    text = body[2].body

    assert_equal(true, check_error_var(text))

  end

  def check_error_var (text)
    return  text.include?(DisqusHelper::ERROR_VAR)
  end

  def test_is_course_supported
    params = {DisqusController::COURSE_NUMBER_PARAM => DisqusHelper::TEST_COURSE}
    assert_equal(true, @controller.is_course_supported(params))

    params = {DisqusController::COURSE_NUMBER_PARAM => nil}
    assert_equal(false, @controller.is_course_supported(params))

    params = {DisqusController::COURSE_NUMBER_PARAM => ""}
    assert_equal(false, @controller.is_course_supported(params))

    params = {DisqusController::COURSE_NUMBER_PARAM => "123456"}
    assert_equal(false, @controller.is_course_supported(params))

  end
end
