class RatingsController < ApplicationController
  def create
    @rater = respond_to?(:current_rater) ? current_rater : params[:rater_type].constantize.find_by_id(params[:rater_id])
    @rating = @rater.rate(params[:rating])
    
    respond_to do |format|
      if (@rating.new_record? ? @rating.save : @rating.update_attribute(:score, params[:score]))
        format.html { render :inline => "<%= rating_tag(@rater, @rating.ratable) %><p>Rating successful, your rating: #{@rating.score}</p>"}
      else
        format.html { render :inline => "Internal error occured."}
      end
    end
  end    
end
