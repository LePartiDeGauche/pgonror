class IncreaseMembershipColumns < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
      execute "alter table memberships modify `job` varchar(80)"
      execute "alter table memberships modify `assoc` varchar(80)"
      execute "alter table memberships modify `union` varchar(80)"
    end
  end

  def down
  end
end
