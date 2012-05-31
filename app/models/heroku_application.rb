class HerokuApplication < ActiveRecord::Base
  attr_accessible :name
  after_destroy :delete_instance

  #need to check name is avail and unique on create

  
  def pending?
    provisioned_at.blank?
  end

  def provision!(name, heroku_id, git_url)
    self.name ||= name
    self.heroku_id = heroku_id 
    self.git_url = git_url 
    self.provisioned_at = Time.now
    self.save
  end

  def url
    "https://#{name}.herokuapp.com"
  end

  def repo
    "git@heroku.com:#{name}.git"
  end
  
  def provision_instance!
    HerokuProvisioner.new(Diaspora.new(self)).create!
  end

  def delete_instance
    begin
      HerokuInstance.new(self).destroy!
    rescue
    end
  end
end