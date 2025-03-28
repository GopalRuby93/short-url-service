# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# Short URL Service
This is a Ruby on Rails application that allows users to shorten long URLs into compact, shareable short URLs.

Prerequisites
Make sure you have the following installed:

Ruby (>= 3.0)

Rails (>= 7.0)

PostgreSQL(for development)

Installation & Setup
Clone the Repository
git clone git@github.com:GopalRuby93/short-url-service.git
cd short-url-service
Install Dependencies
bundle install
Configure Database
Update config/database.yml with your database credentials.
Then run:
rails db:create db:migrate
Start the Server
rails s -p 3001
The app will be available at http://localhost:3001
API Documentation (Swagger UI) 📜
This application uses Swagger UI for API documentation.

Access Swagger UI
Start the Rails server and visit:
🔗 http://localhost:3001/api-docs

Generate Swagger Documentation
If you make changes to the API, update the documentation by running:
rake rswag:specs:swaggerize

API Endpoints
Shorten a URL
Endpoint: POST /api/v1/short_url_generators
Request Body:
{
  "short_url": {
    "original_url": "https://interviewready.io/learn/system-design-course/zoom_meets/nov-2024-system-design-of-chatgpt"
  }
}
Response:
{
    "data": {
        "short_url": "http://127.0.0.1:3001/000000n"
    },
    "message": "Short url created successfully",
    "errors": [],
    "success": true
}
Running Tests
Run the test suite with:
bundle exec rspec spec/folder_name/path_to_your_test_file.spec.rb

Contributing
Fork the repo

Create a new branch: git checkout -b feature-name

Commit changes: git commit -m "Add new feature"

Push and create a Pull Request
