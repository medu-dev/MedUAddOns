require 'test_helper'

class DisqusHelperTest < ActionView::TestCase

  CARD_TITLE = "test title"

  def test_build_var
    result = 'var disqus_title = "test title";'
    var = DisqusHelper.build_variable(DisqusHelper::DISQUS_TITLE,  CARD_TITLE )
    assert_not_nil(var)
    assert_equal(result, var)
  end
end
