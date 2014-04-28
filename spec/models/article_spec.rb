# encoding: utf-8
# PGonror is the corporate web site framework of Le Parti de Gauche based on Ruby on Rails.
# 
# Copyright (C) 2013 Le Parti de Gauche
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# 
# See doc/COPYRIGHT.rdoc for more details.
require 'spec_helper'
describe Article do
  context "Validations" do
    it { should_not have_valid(:title).when('') }
    it { should_not have_valid(:category).when('') }
    it { should_not have_valid(:published_at).when(nil) }
    it { should_not have_valid(:expired_at).when(nil) }
    it { should_not have_valid(:updated_by).when(nil) }

    it "uri is unique" do
      article = FactoryGirl.create(:article, :title => "Article unique")
      article2 = FactoryGirl.build(:article, :title => "Article unique")
      article2.should_not be_valid
      article2.error_on(:uri).should_not be_empty
    end

    it "title can't be ended with a colon" do
      article = FactoryGirl.build(:article, :title => "Titre:")
      article.should_not be_valid
      article.error_on(:title).should_not be_empty
    end

    it "heading can't be ended with a colon" do
      article = FactoryGirl.build(:article, :heading => "Surtitre:")
      article.should_not be_valid
      article.error_on(:heading).should_not be_empty
    end

    it "is valid with heading, title, content, category, publish date, signature and author" do
      article = FactoryGirl.build(:article, :heading => "Test", :signature => "spec")
      article.should be_valid
      article.category_display.should_not be == ""
    end

    it "event is valid with dates and address" do
      article = FactoryGirl.build(:article_event)
      article.should be_valid
      article.category_display.should_not be == ""
      article.start_end_datetime_display.should_not be == ""
      article.start_datetime_display.should_not be == ""
      article.end_time_display.should_not be == ""
      article.end_time?.should be_true
      article.title_to_txt.should_not be == ""
      article.address_to_txt.should_not be == ""
    end

    it "is valid with an image" do
      file = File.open("#{Rails.root}/spec/datafiles/PG-FDG.png")
      article = FactoryGirl.create(:article_image, :title => nil, :image => file)
      article.image_file_name.should_not be_nil
      article.image_content_type.should_not be_nil
      article.image_file_size.should_not be == 0
      article.image_updated_at.should_not be_nil
      article.title.should be == article.image_file_name
      article.image.url(:inline).should_not be_nil
      article.image.url(:large).should_not be_nil
      article.image.url(:zoom).should_not be_nil
      article.image.url(:alternate).should_not be_nil
      article.image.url(:medium).should_not be_nil
      article.image.url(:small).should_not be_nil
      article.image.url(:mini).should_not be_nil
    end

    it "is valid with an image and a watermark" do
      file = File.open("#{Rails.root}/spec/datafiles/Abonnement.png")
      article = FactoryGirl.create(:article_image, :signature => "photosdegauche.fr")
      article.image = file
      article.save!
      article.image_file_name.should_not be_nil
      article.image_content_type.should_not be_nil
      article.image_file_size.should_not be == 0
      article.image_updated_at.should_not be_nil
    end

    it "is valid with an image downloaded from the internet" do
      article = FactoryGirl.create(:article_image,
                                   :title => nil,
                                   :image_remote_url_input => "http://rubyonrails.org/images/rails.png")
      article.image_file_name.should_not be_nil
      article.image_content_type.should_not be_nil
      article.image_file_size.should_not be == 0
      article.image_updated_at.should_not be_nil
      article.image.url(:inline).should_not be_nil
      article.image.url(:large).should_not be_nil
      article.image.url(:zoom).should_not be_nil
      article.image.url(:alternate).should_not be_nil
      article.image.url(:medium).should_not be_nil
      article.image.url(:small).should_not be_nil
      article.image.url(:mini).should_not be_nil
      article.image_remote_url.should_not be_nil
      article.image_remote_url_input.should_not be_nil
    end

    it "is not valid with an bad image" do
      article = FactoryGirl.create(:article_image,
                                   :title => nil,
                                   :image_remote_url_input => "http://aaa/bbb/ccc.png")
      article.image_file_name.should be_nil
    end

    it "is valid with a document" do
      file = File.open("#{Rails.root}/spec/datafiles/textes-Texte-d-orientation.pdf")
      article = FactoryGirl.create(:article_document, :title => nil, :document => file)
      article.document_file_name.should_not be_nil
      article.document_content_type.should_not be_nil
      article.document_file_size.should_not be == 0
      article.document_updated_at.should_not be_nil
      article.title.should be == article.document_file_name
    end

    it "is valid with a sound" do
      file = File.open("#{Rails.root}/spec/datafiles/440Hz-5sec.mp3")
      article = FactoryGirl.create(:article_son, :title => nil, :audio => file)
      article.audio_file_name.should_not be_nil
      article.audio_content_type.should_not be_nil
      article.audio_file_size.should_not be == 0
      article.audio_updated_at.should_not be_nil
      article.title.should be == article.audio_file_name
      article.mp3_duration.should_not be == ""
    end

    it "is valid with a parent" do
      parent = FactoryGirl.create(:article_directory)
      article = FactoryGirl.create(:article, :parent_id => parent.id)
      article.folder.should_not be_nil
      article.folder_display.should_not be == ""
    end

    it "is valid with a source" do
      source = FactoryGirl.create(:article_source)
      article = FactoryGirl.create(:article, :source_id => source.id)
      article.source.should_not be_nil
      article.source_display.should_not be == ""
    end
  end

  context "Scopes" do
    it "#sources returns a list of sources" do
      FactoryGirl.create(:article_source)
      Article.sources.length.should be == 1
    end

    it "#category_option returns a valid option" do
      article = FactoryGirl.create(:article)
      article.category_option(:controller).should_not be_nil
    end

    it "#category_option? returns true" do
      article = FactoryGirl.create(:article)
      article.category_option?(:controller).should be_true
    end

    it "#statuses returns a list of supported statuses" do
      Article.statuses.length.should be == 5
    end

    it "#gravities returns a list of supported gravities" do
      Article.gravities.length.should be == 3
    end

    it "#content_with_inline returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_with_inline.should include("/system/images/inline/")
    end

    it "#content_with_inline_small returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_with_inline_small.should include("/system/images/inline/")
    end

    it "#content_with_large returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_with_large.should include("/system/images/large/")
    end

    it "#content_with_medium returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_with_medium.should include("/system/images/medium/")
    end

    it "#content_replaced_with_medium returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_replaced_with_medium.should include("/system/images/medium/")
    end

    it "#content_with_small returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_with_small.should include("/system/images/small/")
    end

    it "#content_with_mini returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_with_mini.should include("/system/images/mini/")
    end

    it "#content_with_alternate returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_with_alternate.should include("/system/images/alternate/")
    end

    it "#content_replaced_with_zoom returns a content adapted to pages" do
      article = FactoryGirl.create(:article_include_image)
      article.content_replaced_with_zoom.should include("/system/images/zoom/")
    end

    it "#pre_control_authorization returns false if a user can't create content" do
      user = FactoryGirl.create(:publisher)
      Article.pre_control_authorization(user.email, "inter").should_not be_nil
    end

    it "#pre_control_authorization returns true if a user can create content" do
      user = FactoryGirl.create(:publisher)
      FactoryGirl.create(:permission, :user => user)
      Article.pre_control_authorization(user.email, "inter").should be_nil
    end

    it "#control_authorization returns false if a user can't publish content" do
      user = FactoryGirl.create(:publisher)
      article = FactoryGirl.create(:article, :updated_by => user.email)
      article.control_authorization.should be_false
      article.errors.should_not be_empty
    end

    it "#control_authorization returns true if a user can publish content" do
      user = FactoryGirl.create(:publisher)
      FactoryGirl.create(:permission, :user => user)
      article = FactoryGirl.create(:article, :updated_by => user.email)
      article.control_authorization.should be_true
    end

    it "#published? returns true if the article was published" do
      article = FactoryGirl.create(:article)
      article.published?.should be_false
      article.status = Article::ONLINE
      article.save!
      article.published?.should be_true
    end

    it "#was_published? returns true if the article was published before last update" do
      article = FactoryGirl.create(:article)
      article.status = Article::ONLINE
      article.was_published?.should be_false
      article.save!
      article.status = Article::OFFLINE
      article.was_published?.should be_true
    end

    it "#description returns the truncated content of the article with no HTML tag" do
      article = FactoryGirl.create(:article)
      article.description.should_not be_nil
      article.description.should_not include("<")
    end

    it "#status_display returns the status of the article as text" do
      article = FactoryGirl.create(:article)
      article.status_display.should_not be_nil
    end

    it "#status_display_with_style returns the status of the article as text" do
      article = FactoryGirl.create(:article)
      article.status_display_with_style.should_not be_nil
    end

    it "#heading_display returns the heading of the article in a display mode" do
      article = FactoryGirl.create(:article, :heading => "Surtitre")
      article.heading_display.should_not be_nil
    end

    it "#title_display returns the title of the article in a display mode" do
      article = FactoryGirl.create(:article)
      article.title_display.should_not be_nil
    end

    it "#folder_display returns the name of the parent of the article" do
      parent = FactoryGirl.create(:article_directory)
      article = FactoryGirl.create(:article, :parent_id => parent.id)
      article.folder.should_not be_nil
      article.folder_display.should_not be == ""
      article = FactoryGirl.create(:article)
      article.folder.should be_nil
      article.folder_display.should be == ""
    end

    it "#path returns the canonical path of the article" do
      article = FactoryGirl.create(:article)
      article.path.should_not be_nil
    end

    it "#published_datetime returns the published date of the article" do
      article = FactoryGirl.create(:article)
      article.published_datetime.should_not be_nil
    end

    it "#find_published_by_uri returns an article based on an uri" do
      article = FactoryGirl.create(:article)
      article.status = Article::ONLINE
      article.save!
      article = Article.find_published_by_uri article.uri
      article.should_not be_nil
    end

    it "#find_published_by_id returns an article based on an id" do
      article = FactoryGirl.create(:article)
      article.status = Article::ONLINE
      article.save!
      article = Article.find_published_by_id article.id
      article.should_not be_nil
    end

    it "#find_by_criteria returns articles based on various criteria" do
      3.times { article = FactoryGirl.create(:article) }
      articles = Article.find_by_criteria({:category => "inter"})
      articles.length.should be == 3
    end

    it "#find_by_criteria_log returns articles based on various criteria" do
      3.times { article = FactoryGirl.create(:article) }
      articles = Article.find_by_criteria_log({:category => "inter"})
      articles.length.should be == 3
    end

    it "#find_articles_by_parent returns articles attached to a parent" do
      parent = FactoryGirl.create(:article_directory)
      3.times { article = FactoryGirl.create(:article, :parent_id => parent.id) }
      articles = parent.find_articles_by_parent
      articles.length.should be == 3
    end

    it "#find_articles_by_source returns articles attached to a source" do
      source = FactoryGirl.create(:article_source)
      3.times { article = FactoryGirl.create(:article, :source_id => source.id) }
      articles = source.find_articles_by_source
      articles.length.should be == 3
    end

    it "#count_pages_by_criteria counts articles based on various criteria" do
      15.times { article = FactoryGirl.create(:article) }
      articles = Article.count_pages_by_criteria({:category => "inter"})
      articles.should be == 2
    end

    it "#find_published_by_folder returns articles attached to a parent" do
      parent = FactoryGirl.create(:article_directory)
      3.times { 
        article = FactoryGirl.create(:article, :parent_id => parent.id)
        article.status = Article::ONLINE
        article.save!
      }
      articles = parent.find_published_by_folder
      articles.length.should be == 3
    end

    it "#find_published_by_folder_and_category returns articles attached to a parent" do
      parent = FactoryGirl.create(:article_directory)
      3.times { 
        article = FactoryGirl.create(:article, :parent_id => parent.id)
        article.status = Article::ONLINE
        article.save!
      }
      articles = parent.find_published_by_folder_and_category "inter"
      articles.length.should be == 3
    end

    it "#find_published_by_folder_random returns one article attached to a parent" do
      parent = FactoryGirl.create(:article_directory)
      3.times { 
        article = FactoryGirl.create(:article, :parent_id => parent.id)
        article.status = Article::ONLINE
        article.save!
      }
      article = parent.find_published_by_folder_random "inter"
      article.should_not be_nil
    end

    it "#find_last_published returns articles published before" do
      3.times { 
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      last_article = FactoryGirl.create(:article)
      last_article.status = Article::ONLINE
      last_article.save!
      articles = last_article.find_last_published
      articles.length.should be == 3
    end

    it "#find_published_by_heading returns articles published with the same heading" do
      3.times { 
        article = FactoryGirl.create(:article, :heading => "Surtitre")
        article.status = Article::ONLINE
        article.save!
      }
      last_article = FactoryGirl.create(:article, :heading => "Surtitre")
      last_article.status = Article::ONLINE
      last_article.save!
      articles = last_article.find_published_by_heading
      articles.length.should be == 3
    end

    it "#find_published_group_by_heading returns articles published with show_heading option" do
      3.times { 
        article = FactoryGirl.create(:article, :heading => "Surtitre Alpha", :show_heading => true)
        article.status = Article::ONLINE
        article.save!
      }
      3.times { 
        article = FactoryGirl.create(:article, :heading => "Surtitre Beta", :show_heading => true)
        article.status = Article::ONLINE
        article.save!
      }
      headings = Article.find_published_group_by_heading "inter"
      headings.length.should be == 2
    end

    it "#find_published_by_source returns articles attached to a source" do
      source = FactoryGirl.create(:article_source)
      3.times {
        article = FactoryGirl.create(:article, :source_id => source.id)
        article.status = Article::ONLINE
        article.save!
      }
      articles = source.find_articles_by_source
      articles.length.should be == 3
    end

    it "#count_pages_published_by_source counts articles attached to a source" do
      source = FactoryGirl.create(:article_source)
      15.times {
        article = FactoryGirl.create(:article, :source_id => source.id)
        article.status = Article::ONLINE
        article.save!
      }
      articles = source.count_pages_published_by_source
      articles.should be == 2
    end

    it "#find_by_status_group_by_category counts articles by category" do
      3.times { article = FactoryGirl.create(:article) }
      3.times {
        article = FactoryGirl.create(:article)
        article.status = Article::REWORK
        article.save!
      }
      articles = Article.find_by_status_group_by_category(Article::NEW)
      articles.length.should be == 1
      articles = Article.find_by_status_group_by_category(Article::REWORK)
      articles.length.should be == 1
    end

    it "#count_by_status_zoom counts articles with zoom option" do
      3.times {
        article = FactoryGirl.create(:article, :zoom => true)
        article.status = Article::REWORK
        article.save!
      }
      articles = Article.count_by_status_zoom(Article::REWORK)
      articles.should be == 3
    end

    it "#count_by_status_zoom_video counts articles with zoom option" do
      3.times {
        article = FactoryGirl.create(:article, :zoom_video => true)
        article.status = Article::REWORK
        article.save!
      }
      articles = Article.count_by_status_zoom_video(Article::REWORK)
      articles.should be == 3
    end

    it "#find_published returns published articles for a given category" do
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published "inter"
      articles.length.should be == 5
    end

    it "#find_published returns published articles for a given category" do
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published "inter"
      articles.length.should be == 5
    end

    it "#find_all_published returns published articles" do
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_all_published
      articles.length.should be == 5
    end

    it "#find_published_by_heading returns published articles for a given heading" do
      5.times {
        article = FactoryGirl.create(:article, :heading => "Surtitre")
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_by_heading "inter", "surtitre"
      articles.length.should be == 5
    end

    it "#find_published_order_by_title returns published articles for a given category" do
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_order_by_title "inter"
      articles.length.should be == 5
    end

    it "#find_published_order_by_start_datetime returns published articles for a given category" do
      5.times {
        article = FactoryGirl.create(:article_event)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_order_by_start_datetime "evenement"
      articles.length.should be == 5
    end

    it "#count_pages_published_by_start_datetime counts published articles for a given category" do
      15.times {
        article = FactoryGirl.create(:article_event)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.count_pages_published_by_start_datetime "evenement"
      articles.should be == 2
    end

    it "#find_published_zoom returns published articles with zoom option" do
      5.times {
        article = FactoryGirl.create(:article, :zoom => true)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_zoom
      articles.length.should be == 5
    end

    it "#find_published_home_video returns published articles with home_video option" do
      5.times {
        article = FactoryGirl.create(:article, :home_video => true)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_home_video
      articles.length.should be == 5
    end

    it "#find_published_video returns published video articles" do
      5.times {
        article = FactoryGirl.create(:article, :category => "conference")
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_video
      articles.length.should be == 5
    end

    it "#find_published_zoom_video returns published articles with zoom_video option" do
      5.times {
        article = FactoryGirl.create(:article, :zoom_video => true)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_zoom_video
      articles.length.should be == 5
    end

    it "#find_published_exclude_zoom returns published articles without zoom option" do
      5.times {
        article = FactoryGirl.create(:article, :zoom => true)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_exclude_zoom "inter"
      articles.length.should be == 0
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_exclude_zoom "inter"
      articles.length.should be == 5
    end

    it "#find_published_exclude_zoom_video returns published articles without zoom_video option" do
      5.times {
        article = FactoryGirl.create(:article, :zoom_video => true)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_exclude_zoom_video "inter"
      articles.length.should be == 0
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_exclude_zoom_video "inter"
      articles.length.should be == 5
    end

    it "#find_published_video_exclude_zoom returns published video articles without zoom option" do
      5.times {
        article = FactoryGirl.create(:article_video, :zoom => true)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_video_exclude_zoom
      articles.length.should be == 0
      5.times {
        article = FactoryGirl.create(:article_video)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_video_exclude_zoom
      articles.length.should be == 5
    end

    it "#search_published searches published articles" do
      Article.create_default_tag("parti de gauche", "spec@lepartidegauche.fr")
      5.times {
        article = FactoryGirl.create(:article, :heading => "Surtitre", :content => "<p>Article très recherché du Parti de Gauche</p>")
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.search_published "surtitre"
      articles.length.should be == 5
      articles = Article.search_published "parti de gauche"
      articles.length.should be == 5
    end

    it "#count_pages_published counts searched published articles" do
      15.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.count_pages_published "inter"
      articles.should be == 2
    end

    it "#count_pages_published_by_heading counts published articles for a given heading" do
      15.times {
        article = FactoryGirl.create(:article, :heading => "Surtitre")
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.count_pages_published_by_heading "inter", "surtitre"
      articles.should be == 2
    end

    it "#count_pages_search_published counts searched published articles" do
      15.times {
        article = FactoryGirl.create(:article, :heading => "Surtitre")
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.count_pages_search_published "surtitre"
      articles.should be == 2
    end

    it "#find_published_email_articles searches published articles with an email" do
      5.times {
        article = FactoryGirl.create(:article_email)
        article.status = Article::ONLINE
        article.save!
      }
      articles = Article.find_published_email_articles
      articles.length.should be == 6
    end

    it "#all_headings returns all the headings from articles" do
      FactoryGirl.create(:article, :heading => "Surtitre Alpha")
      FactoryGirl.create(:article, :heading => "Surtitre Beta")
      FactoryGirl.create(:article, :heading => "Surtitre Gamma")
      articles = Article.all_headings "surtitre"
      articles.length.should be == 3
    end

    it "#all_signatures returns all the headings from articles" do
      FactoryGirl.create(:article, :signature => "Auteur Alpha")
      FactoryGirl.create(:article, :signature => "Auteur Beta")
      FactoryGirl.create(:article, :signature => "Auteur Gamma")
      articles = Article.all_signatures "auteur"
      articles.length.should be == 3
    end
  end

  context "Behavior" do
    it "destroy" do
      article = FactoryGirl.create(:article)
      article.destroy
    end

    it "#update_title created a default heading based on parent name" do
      parent = FactoryGirl.create(:article_directory)
      article = FactoryGirl.create(:article, :parent_id => parent.id)
      article.heading.should_not be_nil
      article.heading.should_not be == ""
    end

    it "#update_uri creates a default uri based on title" do
      article = FactoryGirl.create(:article)
      article.uri.should_not be_nil
      article.uri.should_not be == ""
    end

    it "#update_content replaces quotes" do
      article = FactoryGirl.create(:article, :content => "<p>Remplacement des 'quotes'.</p>")
      article.content.should_not include("'")
      article.content.should include("&rsquo;")
    end

    it "#update_content replaces references to images" do
      article = FactoryGirl.create(:article_include_image)
      article.content.should_not include("/../../")
      article.content.should include("/system/images/inline/")
    end

    it "#update_content replaces references to image links" do
      article = FactoryGirl.create(:article_include_image_link)
      article.content.should_not include("/../../")
    end

    it "#update_content replaces references to documents" do
      article = FactoryGirl.create(:article_include_document)
      article.content.should_not include("/../../")
      article.content.should include("/system/documents/")
    end

    it "#update_tags creates tags based on title and default tags" do
      Article.create_default_tag("test", "spec@lepartidegauche.fr")
      Article.create_default_tag("tag", "spec@lepartidegauche.fr")
      article = FactoryGirl.create(:article, :title => "Test avec un tag", :content => "<p>Ceci est un test avec un tag.</p>")
      article.status = Article::ONLINE
      article.save!
      article.tags.length.should be == 2
      article.tags_display.should be == "tag,test"
    end

    it "#create_audit! creates audit log" do
      article = FactoryGirl.create(:article)
      article.create_audit!(article.status, article.updated_by, "spec")
      article.audits.length.should be == 1
    end

    it "#activated_categories returns the list of categories that are activated for the given user" do
      user = FactoryGirl.create(:publisher)
      FactoryGirl.create(:permission, :category => 'actu', :user => user, :notification_level => Article::NEW)
      FactoryGirl.create(:permission, :category => 'edito', :user => user, :notification_level => Article::NEW)
      FactoryGirl.create(:permission, :category => 'inter', :user => user, :notification_level => Article::REVIEWED)
      categories = Article.activated_categories user
      categories.length.should be == 3
    end

    it "#defaults assigns default values to the article" do
      article = FactoryGirl.build(:article)
      article.defaults "edito"
      article.should be_valid
      article.save!
    end

    it "#email_notification fires an email to recipients" do
      user = FactoryGirl.create(:publisher)
      FactoryGirl.create(:permission, :user => user, :notification_level => Article::NEW)
      article = FactoryGirl.create(:article, :updated_by => user.email)
      article.email_notification(user.email)
      article.status = Article::ONLINE
      article.save!
      article.email_notification(user.email)
    end
  end
end