class IncreaseDepartmentSize < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
      execute "alter table memberships modify amount decimal(6,2)"
      execute "alter table donations modify amount decimal(6,2)"
      execute "alter table memberships modify department varchar(80)"
      execute "alter table memberships modify email varchar(50)"
      execute "alter table donations modify email varchar(50)"
      execute "alter table requests modify email varchar(50)"
      execute "alter table subscriptions modify email varchar(50)"
      execute "alter table users modify email varchar(50)"
      for department in Membership::DEPARTEMENTS
        limited = department[0..9]
        puts "Update #{limited} >>> #{department}"
        execute "update memberships set department = '#{department.gsub(/\\/, '\&\&').gsub(/'/, "''")}' where department = '#{limited.gsub(/\\/, '\&\&').gsub(/'/, "''")}'"
      end
    end
  end

  def down
  end
end