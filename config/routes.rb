MedUAddOns::Application.routes.draw do

  get "q_unit_test/show"

  get "test_card_questions/show"

  #disqus
  get "comments/show"  #this is for testing
  get "disqus/getcomments"

  # card questions
  get "question_admin/init"
  get "question_admin/get_all"
  get "question_admin/get_courses"
  get "question_admin/get_all_answers"
  get "question_admin/stream_download"
  get "question_admin/question_help"
  post "question_admin/add_question"
  post "question_admin/edit_question"
  post "question_admin/delete_question"
  post "question_admin/delete_relationship"
  post "question_admin/add_relation"
  get "card_questions/init"
  get "card_questions/show"
  post "card_questions/save_answer"
  get "test_card_questions/show"  # for testing
  get "q_unit_test/show"

end
