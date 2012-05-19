require File.dirname(__FILE__) + '/../spec_helper'

describe HerokuApplication do
  it "should be valid" do
    HerokuApplication.new.should be_valid
  end

  describe '#pending?' do
    it 'should be pending if provisioned_at is nil' do
      HerokuApplication.new.should be_pending
    end 
  end

  describe '#provision!' do
    it 'sets the name, heroku_id, and sets the provisioned_at and saves it' do
      app = HerokuApplication.new
      app.provision!("cool", "1123")

      app.name.should be_present
      app.heroku_id.should be_present
      app.should be_persisted
    end
  end
end
