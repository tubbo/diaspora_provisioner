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
    add_config_vars
    set_up_user_env_compile
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

  def add_config_vars
    Rails.logger.info 'adding config put_config_vars'
    client.put_config_vars(@app.name, 'HEROKU' => 'true', 'SECRET_TOKEN' => SecureRandom.hex(40))

    #s3 for asset_sync
    client.put_config_vars(@app.name, 'AWS_ACCESS_KEY_ID' =>  ENV['AWS_ACCESS_KEY_ID'], 
                                      'AWS_SECRET_ACCESS_KEY' => ENV['AWS_SECRET_ACCESS_KEY'], 
                                      'FOG_DIRECTORY' => ENV['FOG_DIRECTORY'],
                                      'FOG_PROVIDER' => ENV['FOG_PROVIDER'],
                                      'ASSET_HOST' => "https://#{ENV['FOG_DIRECTORY']}.s3.amazaonaws.com"
                                      )

   end

  def set_up_addons
    ADDONS.each do |a|
      Rails.logger.info "Adding #{a}"
      client.post_addon(@app.name, a)
    end
  end

  def set_up_user_env_compile
    Rails.logger.info "setting up user env compile"
    system "heroku labs:enable user_env_compile -a #{@app.name}"
  end

  def migrate
    Rails.logger.info "migrating app"
    client.post_ps(@app.name, 'run rake db:migate')
    system "heroku run rake db:migrate -a #{@app.name}"
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
    client.post_ps_restart(@app.name)
  end


  def with_git(&block)
    Dir.chdir(DIASPORA_DIRECTORY) do
      system "git remote rm heroku" #double check
      system "git remote add heroku #{@app.git_url}"
      yield 
      system "git remote rm heroku"
    end

    Rails.logger.info "done with git"
  end
end