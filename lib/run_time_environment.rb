class RunTimeEnvironment

  PRODUCTION = "production"
  DEVELOPMENT = "development"
  STAGING = "staging"
  TEST = "test"

  def self.get_runtime_environment
    environment =   Rails.env

    return environment
  end

  def self.is_production?
       return Rails.env.production?
  end

def self.is_development?
  return Rails.env.development?
end

  def self.is_staging?
    return Rails.env.staging?
  end

  def self.is_test?
    return Rails.env.test?
  end

  def self.log_runtime_environment
    puts  "---- Rails Env: " + Rails.env
  end

end