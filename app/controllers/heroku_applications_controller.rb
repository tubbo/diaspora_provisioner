class HerokuApplicationsController < ApplicationController
  def index
    @heroku_applications = HerokuApplication.all
  end

  def show
    @heroku_application = HerokuApplication.find(params[:id])
  end

  def new
    @heroku_application = HerokuApplication.new
  end

  def create
    @heroku_application = HerokuApplication.new(params[:heroku_application])
    if @heroku_application.save

      @heroku_application.provision_instance!

      redirect_to @heroku_application, :notice => "New App Created!"
    else
      render :new
    end
  end

  def edit
    @heroku_application = HerokuApplication.find(params[:id])
  end

  def update
    @heroku_application = HerokuApplication.find(params[:id])
    if @heroku_application.update_attributes(params[:heroku_application])
      redirect_to @heroku_application, :notice  => "Successfully updated heroku application."
    else
      render :edit
    end
  end

  def destroy
    @heroku_application = HerokuApplication.find(params[:id])
    @heroku_application.destroy
    redirect_to heroku_applications_url, :notice => "Successfully destroyed heroku application."
  end
end
