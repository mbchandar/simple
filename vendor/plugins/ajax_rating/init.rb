require 'ajax_rating'
ActionView::Base.send(:include, AjaxRating::RatingHelper)
ActiveRecord::Base.send(:include, AjaxRating::ActiveRecord)