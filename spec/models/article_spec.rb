# encoding: utf-8
# PGonror is the corporate web site framework of Le Parti de Gauche based on Ruby on Rails.
# 
# Copyright (C) 2012 Le Parti de Gauche
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
    it "fabrique par défaut doit être valide" do
      FactoryGirl.build(:article).should be_valid
    end
    it { should_not have_valid(:title).when('') }
    it { should_not have_valid(:category).when('') }
    
    it "URI est unique" do
      @article = FactoryGirl.create(:article, :title => "mon article")
      @article2 = FactoryGirl.build(:article, :title => "mon article")
      @article2.should_not be_valid
      @article2.error_on(:uri).should_not be_empty
    end
    
    it "est valide avec un titre, un contenu, une catégorie, une date de publication et un auteur" do
      @article = FactoryGirl.build(:article)
      @article.stub(:control_authorization).and_return(true)
      @article.should be_valid
    end
  end
  
  context "Scopes" do
    it "#find_all_published récupère tous les articles publiés" do
      5.times { FactoryGirl.create(:published_article) }
      3.times { FactoryGirl.create(:article) }
      @articles = Article.find_all_published
      pending "la liste des articles devrait contenir que 5 et non 0" do
        @articles.length.should == 5
      end
    end
  end
  
  context "Comportements" do
    it "#was_published? dit si l'article était publié avant la dernière modification" do
      @article = FactoryGirl.create(:article)
      @article.status = Article::ONLINE
      @article.was_published?.should be_false
      @article.save!
      
      @article.status = Article::OFFLINE
      @article.was_published?.should be_true      
    end
  end
end
