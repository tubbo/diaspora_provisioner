class CreateHerokuApplications < ActiveRecord::Migration
  def self.up
    create_table :heroku_applications do |t|
      t.string :name
      t.string :heroku_id
      t.string :git_url
      t.datetime :provisioned_at
      t.timestamps
    end
  end

  def self.down
    drop_table :heroku_applications
  end
end
