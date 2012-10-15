class DeleteCategoryDeclaration < ActiveRecord::Migration
  def up
    execute "delete from articles where category='type' and uri='decl'"
  end

  def down
  end
end
