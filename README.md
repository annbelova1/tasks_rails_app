Rails-приложение, для управления задачами (Tasks) (код на ветке develop)

# Set Up

1. docker-compose build
2. docker-compose up -d
3. docker-compose run app rails db:create db:migrate db:seed
4. docker-compose up app

'http://localhost:3000/users/sign_up'

# Specs

docker-compose run -e "RAILS_ENV=test" app bundle exec rspec

