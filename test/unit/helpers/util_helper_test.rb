require 'test_helper'

class UtilHelperTest < ActionView::TestCase

  def setup
    @cardid_1 = 72
    @cardid_2 = 48
    @body = "Why id the chicken cross the road?"
    @body2 = "Will we go over the fiscal cliff?"
  end

  def test_is_card_supported
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)

    params = { UtilHelper::PARAM_CARDID => @cardid_1.to_s}
    found = UtilHelper.is_card_supported(params)
    assert_equal(true, found)
  end

  def test_unknown_card
    params = { UtilHelper::PARAM_CARDID => "00"}
    found = UtilHelper.is_card_supported(params)
    assert_equal(false, found)
  end

  def test_no_param
    params = { }
    found = UtilHelper.is_card_supported(params)
    assert_equal(false, found)
  end

  def test_replace_card_id_tag
    str = "Now is the time "+ UtilHelper::SUB_CARDID+ "xyzzy"
    card_id = "47"

    found = UtilHelper.replace_card_id_tag(str, card_id)

    assert_not_nil(found)
    assert_equal(true, str.include?(card_id))
    assert_equal(true, str.include?(card_id+"xyzzy"))

  end

  def test_replace_no_card_id_tag
    str = "Now is the time "
    card_id = "47"

    found = UtilHelper.replace_card_id_tag(str, card_id)

    assert_nil(found)
  end

  def test_replace_user_id_tag
    str = "Now is the time "+ UtilHelper::SUB_USERID+ "xyzzy"
    user_id = "1492"

    found = UtilHelper.replace_user_id_tag(str, user_id)

    assert_not_nil(found)
    assert_equal(true, str.include?(user_id))
    assert_equal(true, str.include?(user_id+"xyzzy"))
  end

  def test_replace_no_user_id_tag
    str = "Now is the time "
    user_id = "1492"

    found = UtilHelper.replace_user_id_tag(str, user_id)

    assert_nil(found)
  end

  def test_get_user_id
    test_id = "1492"
    params = { UtilHelper::PARAM_USERID => test_id}

    user_id = UtilHelper.get_user_id(params)
    assert_equal(test_id, user_id)
  end

  def test_get_no_user_id
    params = { }

    user_id = UtilHelper.get_user_id(params)
    assert_equal(UtilHelper::UNKNOWN_USER, user_id)
  end

end
