MedUAddOns::Application.routes.draw do

  get "q_unit_test/show"

  get "test_card_questions/show"

  #disqus
  get "comments/show"  #this is for testing
  get "disqus/getcomments"

  # card questions
  get "question_admin/init"
  get "card_questions/init"
  get "card_questions/show"
  post "card_questions/save_answer"
  get "test_card_questions/show"  # for testing
  get "q_unit_test/show"

end
