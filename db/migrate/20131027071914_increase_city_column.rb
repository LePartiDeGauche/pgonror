class IncreaseCityColumn < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
      execute "alter table memberships modify city varchar(80)"
      execute "alter table donations modify city varchar(80)"
      execute "alter table requests modify city varchar(80)"
    end
  end

  def down
  end
end
