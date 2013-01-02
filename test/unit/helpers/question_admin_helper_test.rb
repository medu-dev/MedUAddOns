require 'test_helper'

class QuestionAdminHelperTest < ActionView::TestCase

  def setup
    @cardid_1 = 72
    @cardid_2 = 48
    @body = "Why id the chicken cross the road?"
    @body2 = "Will we go over the fiscal cliff?"
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

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)
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

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_2)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_2)

    all = QuestionAdminHelper.select_all()
    assert_equal(true, all.length == 2)
  end

  def test_select_relationships_for_card
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    question2 = QuestionAdminHelper.create_question(@body2)

    assert_equal(true, question2.id > 0)
    assert_equal(true, question2.body == @body2)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)

    relationship = QuestionAdminHelper.create_relationship(question2.id, @cardid_1)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question2.id)
    assert_equal(true, relationship.card_id == @cardid_1)

    all = QuestionAdminHelper.select_questions_for_card(@cardid_1)
    assert_equal(true, all.length == 2)
    assert_equal(@body, all[0]["body"])
    assert_equal(@body2, all[1]["body"])
  end


end
