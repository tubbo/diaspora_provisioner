require 'fog'

class HerokuProvisioner

  attr_accessor :app
  
  def initialize(app)
    @app = app
  end

  def create!
    response = initialize_app
    @app.provision!(response['name'], response['id'], response['git_url'])
    add_config_vars
    set_up_heroku_labs
    set_up_addons
    create_bucket
    push
    migrate
    restart
    message
    @app
  end

  def migrate
    Rails.logger.info "migrating app"
    heroku "run rake db:migrate"
  end

  def add_ssl
    #heroku addons:add ssl:endpoint <= costs $$$, and needs to fetch the url from an email :( )
  end

  def update
    #pull in git
    #push to heroku
    #migrate
    #restart
  end

  def restart
    client.post_ps_restart(@app.name)
  end

  def destroy!
    client.delete_app(@app.name)
  end

  private

  def create_bucket
    storage = Fog::Storage.new(
    {:aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
     :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
     :provider => 'AWS'}
     )
    storage.directories.create(:key => @app.name)
  end

  def initialize_app
    Rails.logger.info 'initializing app'
    client.post_app('stack' => 'cedar', 'name' => @app.name).body
  end

  def add_config_vars
    Rails.logger.info 'adding config vars'
    client.put_config_vars(@app.name, @app.config_vars)
   end

  def set_up_addons
    @app.add_ons.each do |a|
      Rails.logger.info "Adding #{a}"
      client.post_addon(@app.name, a)
    end
  end

  def set_up_heroku_labs
    @app.heroku_labs.each do |feature|
      Rails.logger.info "setting up heroku:labs #{feature}"
      heroku "labs:enable #{feature}" 
    end
  end

  private
  def message
    puts "things left to do:"
    puts "add custom domains"
    puts "add ssl"
    puts "correctly set up application.yml :(" 
  end

  def client
    @client ||= Heroku::API.new(:api_key => ENV['HEROKU_API_KEY'])
  end

  def push
    in_app_directory do
      Rails.logger.info "pushing repo"
      system "git push #{@app.repo} master"
    end
  end

  def in_app_directory(&block)
    Dir.chdir(@app.location) do
      yield
    end
    Rails.logger.info "done with git"
  end

  def heroku(cmd)
    system "heroku #{cmd} -a #{@app.name}"
  end
end