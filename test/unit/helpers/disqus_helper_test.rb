require 'test_helper'

class DisqusHelperTest < ActionView::TestCase

  CARD_TITLE = "test title"

  def test_is_supported_course
    assert_equal(true, DisqusHelper.is_supported?(DisqusHelper::TEST_COURSE))
    assert_equal(false, DisqusHelper.is_supported?("xyzzy"))
    assert_equal(false, DisqusHelper.is_supported?(nil))
    assert_equal(true, DisqusHelper.is_supported?("3420"))
  end

  def test_error_setup
    error_msg = "no title"

    msg = DisqusHelper.set_error(error_msg)
    assert_equal(true, msg.include?(error_msg))
    assert_equal(true, msg.include?(DisqusHelper::ERROR_VAR))
  end

  def test_replace_tag
    str = ""
    prefix = "var disqus_shortname = '"
    value = "medu "
    semi_colon = "';"

    assert_nil(DisqusHelper.replace_tag(str, DisqusHelper::SHORTNAME_TAG, value))

    str = prefix + DisqusHelper::SHORTNAME_TAG  + semi_colon
    full_str = prefix + value  + semi_colon
    assert_not_nil(DisqusHelper.replace_tag(str, DisqusHelper::SHORTNAME_TAG, value))
    assert_equal(true, str.include?(value))
    assert_equal(false, str.include?(DisqusHelper::SHORTNAME_TAG))
    assert_equal(true, str == full_str)
  end

  def test_replace_developer
    text = read_comments_fixture
    assert_not_nil(text)

    str = DisqusHelper.replace_developer_tag(text)
    assert_not_nil(str)
    assert_equal(true, text.include?("'1'"))
  end

  def test_replace_shortname
    text = read_comments_fixture
    assert_not_nil(text)

    str = DisqusHelper.replace_shortname_tag(text)
    assert_not_nil(str)
    assert_equal(true, text.include?(DisqusHelper::TESTING_SHORTNAME))
  end

  # utility methods
  def read_comments_fixture
    template = ""
    path = "test/fixtures/comments.txt"
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
end
