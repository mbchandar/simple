class RatableGenerator < Rails::Generator::Base
  def manifest
    recorded_session = record do |m|
      m.file "helpers/ratings_helper.rb", "app/controllers/ratings_helper.rb"
      m.file "controllers/ratings_controller.rb", "app/controllers/ratings_controller.rb"
      m.file "models/rating.rb", "app/models/rating.rb"
      m.file "stylesheets/rating.css", "public/stylesheets/rating.css"
      m.file "images/star1.png", "public/images/star1.png"
      m.file "images/star2.png", "public/images/star2.png"
      m.file "images/star3.png", "public/images/star3.png"
      
      m.migration_template 'migrations/create_ratings.rb', 'db/migrate', :assigns => {
          :migration_name => "CreateRatings"
        }, :migration_file_name => "create_ratings"
      
      m.route_resources 'ratings'
    end
    
    action = nil
    action = $0.split("/")[1]
    case action
      when "generate" 
        puts
        puts ("-" * 70)
        puts "Thanks for using Ajax Rating, Bug report to yzhang@elctech.com"
        puts ("-" * 70)
        puts
      else
        puts
    end

    recorded_session
  end
end
