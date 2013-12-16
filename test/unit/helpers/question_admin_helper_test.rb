require 'test_helper'

class QuestionAdminHelperTest < ActionView::TestCase

  def setup
    @cardid_1 = 72
    @cardid_2 = 48
    @body = "Why id the chicken cross the road?"
    @body2 = "Will we go over the fiscal cliff?"
    @course_id = 3420
  end

  def test_create_question
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)
  end

  def test_create_relationship
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1, @course_id)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)
    assert_equal(true, relationship.course_id == @course_id)
  end

  def test_select_question_by_id
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    question2 = QuestionAdminHelper.select_question(question.id)
    assert_equal(true, question2.id > 0)
    assert_equal(true, question2.body == @body)
  end

  def test_select_relationships
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1, @course_id)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)
    assert_equal(true, relationship.course_id == @course_id)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_2, @course_id)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_2)
    assert_equal(true, relationship.course_id == @course_id)

    all = QuestionAdminHelper.select_all()
    assert_equal(true, all.length == 2)
  end

  def test_correct_course_name
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1, @course_id)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)
    assert_equal(true, relationship.course_id == @course_id)


    all = QuestionAdminHelper.select_all()
    assert_equal(true, all.length == 1)
    assert_equal(true, all[0].course_name == "CLIPP")
  end

  def test_select_no_relationships
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    all = QuestionAdminHelper.select_all()
    assert_equal(true, all.length == 1)
  end


  def test_select_relationships_for_card
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    question2 = QuestionAdminHelper.create_question(@body2)

    assert_equal(true, question2.id > 0)
    assert_equal(true, question2.body == @body2)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1, @course_id)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)
    assert_equal(true, relationship.course_id == @course_id)

    relationship = QuestionAdminHelper.create_relationship(question2.id, @cardid_1, @course_id)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question2.id)
    assert_equal(true, relationship.card_id == @cardid_1)
    assert_equal(true, relationship.course_id == @course_id)

    all = QuestionAdminHelper.select_questions_for_card(@cardid_1)
    assert_equal(true, all.length == 2)
    assert_equal(@body, all[0]["body"])
    assert_equal(@body2, all[1]["body"])
  end

  def test_make_unique_file_identifier
    identifier = QuestionAdminHelper.get_unique_identifier
    assert_not_nil(identifier)
  end

  def test_order_cards
    x = "<< 1>> now is the time for all"
    assert_equal(1, QuestionAdminHelper.get_order(x))
    a = "<<12>> now is the time for all"
    assert_equal(12, QuestionAdminHelper.get_order(a))
    c = "no tag present"
    assert_nil(QuestionAdminHelper.get_order(c))
    d = "<<4 half a tag"
    assert_nil(QuestionAdminHelper.get_order(d))
    e = "<<14. >> now is the time"
    assert_equal(14, QuestionAdminHelper.get_order(e))
    e = "<<15.gh >> now is the time"
    assert_equal(15, QuestionAdminHelper.get_order(e))
  end

  def test_remove_order_from_body
    test_str ="now is the time for all good men"
    x = "<< 1>> " + test_str
    assert_equal(1, QuestionAdminHelper.get_order(x))

    assert_equal(test_str, QuestionAdminHelper.remove_order_tag(x))
    z = 0

  end



end
