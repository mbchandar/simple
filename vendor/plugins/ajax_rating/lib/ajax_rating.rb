module AjaxRating
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def acts_as_ratable
        has_many :ratings, :as => 'ratable'
        include AjaxRating::Ratable
      end
      
      def acts_as_rater
        has_many :ratings, :as => 'rater'
        include AjaxRating::Rater
      end        
    end
  end
  
  module Ratable
    def rating
      @rating ||= ratings.count.zero? ? 0 : ratings.sum('score') / ratings.count
    end
    
    def rating_count
      ratings.count
    end
  end
  
  module Rater
    def rate(rating)
      ratings.find_by_ratable_id_and_ratable_type(rating[:ratable_id], rating[:ratable_type]) ||
               ratings.build(rating)
    end
    
    def rating_on(ratable)
      rating = ratings.find_by_ratable_id_and_ratable_type(rating[:ratable_id], rating[:ratable_type])
      rating.nil? ? 0 : rating.score
    end
  end
  
  module RatingHelper
    def rating_link(title, score, style, rater, ratable, update_tag)
      if rater
        link_to_remote(score, :update => update_tag, 
                :url => ratings_path(:rating => {:ratable_type => ratable.class.to_s,
                                                 :ratable_id => ratable.id,
                                                 :score => score},
                                     :rater_id => rater.id,
                                     :rater_type => rater.class.to_s),
                :method => 'post',
                :html => { :class => style, :title => title})
      else
        link_to score, '', :class => style
      end
    end
  
    def rating_tag(rater, ratable)
      update_tag = "rating#{ratable.id}"
    
      content_tag(:div, :id => update_tag, :class => 'rating') do
        content_tag(:ul, :class => "star-rating") do
          content_tag(:li, '', :class => "current-rating", :style => "width:#{20 * ratable.rating}px;") +
            content_tag(:li, rating_link('1 star', '1', 'one-star', rater, ratable, update_tag)) +
            content_tag(:li, rating_link('2 stars', '2', 'two-stars', rater, ratable, update_tag)) +
            content_tag(:li, rating_link('3 stars', '3', 'three-stars', rater, ratable, update_tag)) +
            content_tag(:li, rating_link('4 stars', '4', 'four-stars', rater, ratable, update_tag)) +
            content_tag(:li, rating_link('5 stars', '5', "five-stars", rater, ratable, update_tag))
        end
      end
    end
  end
end
