class HerokuApplication < ActiveRecord::Base
  attr_accessible :none
  after_destroy :delete_instance
  # after_create :provision_instance

  def pending?
    provisioned_at.blank?
  end

  def provision!(name, heroku_id, git_url)
    self.name = name
    self.heroku_id = heroku_id 
    self.git_url = git_url 
    self.provisioned_at = Time.now
    self.save
  end

  def url
    "https://#{name}.herokuapp.com"
  end
  
  def provision_instance
    iHerokuInstance.new(self).create!
  end

  def delete_instance
    begin
      HerokuInstance.new(self).destroy!
    rescue
    end
  end
end