class Diaspora
  attr_accessor :heroku_application
  delegate :name, :git_url, :heroku_id, :provision!, :repo,  :to => :heroku_application

  def initialize(heroku_application)
    @heroku_application = heroku_application
  end

  def location
    Rails.root.join('vendor/diaspora')
  end

  def add_ons
    ['heroku-postgresql:dev', 'redistogo:nano']
  end

  def heroku_labs
    ['user_env_compile']
  end

  def config_vars
    {
      'HEROKU' => 'true', 
      'SECRET_TOKEN' => SecureRandom.hex(40),
      'AWS_ACCESS_KEY_ID' =>  ENV['AWS_ACCESS_KEY_ID'], 
      'AWS_SECRET_ACCESS_KEY' => ENV['AWS_SECRET_ACCESS_KEY'], 
      'FOG_DIRECTORY' => name || ENV['FOG_DIRECTORY'],
      'FOG_PROVIDER' => ENV['FOG_PROVIDER'],
      'ASSET_HOST' => "https://#{name}.s3.amazonaws.com",
      'NEW_HOTNESS' => 'yesplze',
      'ERROR_PAGE_URL' => 'https://s3.amazonaws.com/joindiaspora/sorry.html',
      'MAINTENANCE_PAGE_URL' => 'https://s3.amazonaws.com/joindiaspora/5xx.html',
      'application_yml' => 'changeme'
    }
  end
end