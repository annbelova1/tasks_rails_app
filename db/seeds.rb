# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


5.times do |i|
    @user = User.create!(
        name: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        email: "#{Faker::Internet.user_name}@gmail.com", 
        password: '123456789', 
        password_confirmation: '123456789')  
    puts "User Created: #{@user.email}"
end

User.all.each do |user|
    5.times do |i|
        @task = user.tasks.create!(name: Faker::Lorem.sentence, created_at: Time.now - rand(356).days)
        @task.update(status: Task::STATUSES.map { |i| i[0] }.shuffle.first)
        if @task.canceled?
            @task.update(canceled_at: Time.now - rand(356).days)
        elsif @task.completed?
            @task.update(completed_at: Time.now - rand(356).days)
        end
        puts "Task Created: #{@task.name}"
    end
end



# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

