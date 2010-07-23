namespace :db do
  desc "Erase and fill db"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Product,User].each(&:delete_all)

    User.populate 1 do |user|
      user.login = "mbchandar"
      user.email = "mbchandar@gmail.com"
      user.created_at = Time.now
      user.activated_at = Time.now
      user.activation_code = Populator.words(1...6)
      
      salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--mbchandar--")
      user.salt = salt
      user.crypted_password = Digest::SHA1.hexdigest("--#{salt}--chandar--")      
      Product.populate 1..3 do |product|
        product.title = Populator.words(1..5).titleize
        product.description = Populator.sentences(2..10)
        #product.price = [4.99,19.95,100]
        product.created_at = 2.years.ago..Time.now        
      end
    end
  end
end