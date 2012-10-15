class MoveIntroductionIntoContent < ActiveRecord::Migration
  def up
    for article in Article.where('introduction is not null')
      puts "-- Update article #{article.title}"
      article.transaction do
        article.updated_by = "[Auto]"
        article.content = article.introduction + (article.content.nil? ? "" : article.content)
        article.introduction = nil
        article.save!
        article.create_audit! article.status, article.updated_by
      end
    end
  end

  def down
  end
end