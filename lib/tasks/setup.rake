  task :setup do
    puts "setting up the app"
    
    Rake::Task['db:drop:all'].invoke
    Rake::Task['db:create:all'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:fixtures:load'].invoke
  end

