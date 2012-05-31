class CreateDiasporaInstance
  @queue = :general
  
  def self.perform(heroku_app_id)
    app = HerokuApplication.find(heroku_app_id)
    app.provision_instance!
  end
end