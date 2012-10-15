class UpdateDepartmentInMemberships < ActiveRecord::Migration
  def change
    for membership in Membership.all
      print "Update #{membership.department}..." ; STDOUT.flush
      department = Article.where("id = ?", membership.department).first
      if department.present?
        execute "update memberships set department='#{department.title.gsub(/'/, "''")}' where id=#{membership.id}"
        puts "OK"
      else
        puts "Not found"
      end
    end
  end
end
