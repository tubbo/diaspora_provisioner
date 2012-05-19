require 'spec_helper'

describe HerokuInstance do

  describe 'initialize' do
    it 'takes a Heroku Application' do
      i = HerokuInstance.new("foo")
      i.app.should == "foo"
    end
  end
end