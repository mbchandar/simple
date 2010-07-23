namespace :db do
  desc "active"
  
  task :activate, [:code] do |t, args|
     require 'config/environment'

     user = User.find_by_activation_code(args.code)
     user.activated_at = Time.now
     user.state = "active"
     user.save!
     puts "user got activated"
  end
end


  