require File.dirname(__FILE__) + '/../spec_helper'

describe HerokuApplicationsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => HerokuApplication.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    HerokuApplication.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    HerokuApplication.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(heroku_application_url(assigns[:heroku_application]))
  end

  it "edit action should render edit template" do
    get :edit, :id => HerokuApplication.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    HerokuApplication.any_instance.stubs(:valid?).returns(false)
    put :update, :id => HerokuApplication.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    HerokuApplication.any_instance.stubs(:valid?).returns(true)
    put :update, :id => HerokuApplication.first
    response.should redirect_to(heroku_application_url(assigns[:heroku_application]))
  end

  it "destroy action should destroy model and redirect to index action" do
    heroku_application = HerokuApplication.first
    delete :destroy, :id => heroku_application
    response.should redirect_to(heroku_applications_url)
    HerokuApplication.exists?(heroku_application.id).should be_false
  end
end
