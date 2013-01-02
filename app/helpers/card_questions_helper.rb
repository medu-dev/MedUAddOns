module CardQuestionsHelper

def self.make_id(id, suffix)
  return id + suffix.to_s
end

end
