class HerokuInstance
  DIASPORA_DIRECTORY = Rails.root.join('vendor/diaspora')
  ADDONS = ['redistogo:nano']
  attr_accessor :app
  def initialize(app)
    @app = app
  end

  def create!
    response = initialize_app
    @app.provision!(response['name'], response['id'], response['git_url'])
    set_up_addons
    push
    migrate
    restart
  end

  def destroy!
    client.delete_app(@app.name)
  end


  private

  def initialize_app
    Rails.logger.info 'initializing app'
    client.post_app('stack' => 'cedar').body
  end

  def set_up_addons
    ADDONS.each do |a|
      Rails.logger.info "Adding #{a}"
      client.post_addon(@app.name, a)
    end
    set_up_user_env_compile
  end

  def set_up_user_env_compile
    Rails.logger.info "setting up user env compile"
    system "heroku labs:enable user_env_compile -a #{@app.name}"
  end

  def migrate
    Rails.logger.info "migrating app"
    client.post_ps(@app.name, 'run rake db:migate')
  end

  def client
    @client ||= Heroku::API.new(:api_key => ENV['HEROKU_API_KEY'])
  end


  def push
    with_git do
      Rails.logger.info "pushing repo"
      system 'git push heroku master'
    end
  end

  def restart
    post_ps_restart(@app.name)
  end


  def with_git(&block)
    Dir.chdir(DIASPORA_DIRECTORY) do
      system "git remote add heroku #{@app.git_url}"
      yield 
      system "git remote rm heroku"
    end

    Rails.logger.info "done with git"
  end
end