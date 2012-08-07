require 'test_helper'

class DisqusHelperTest < ActionView::TestCase

  CARD_TITLE = "test title"

  def test_build_var
    result = 'var disqus_title = "test title";'
    var = DisqusHelper.build_variable(DisqusHelper::DISQUS_TITLE,  CARD_TITLE )
    assert_not_nil(var)
    assert_equal(result, var)
  end

  def test_is_supported_course
    assert_equal(true, DisqusHelper.is_supported?(DisqusHelper::TEST_COURSE))
    assert_equal(false, DisqusHelper.is_supported?("xyzzy"))
    assert_equal(false, DisqusHelper.is_supported?(nil))
  end

  def test_error_setup
    error_msg = "no title"

    msg = DisqusHelper.set_error(error_msg)
    assert_equal(true, msg.include?(error_msg))
    assert_equal(true, msg.include?(DisqusHelper::ERROR_VAR))
  end
end
