# Pup

[![Build Status](https://travis-ci.org/andela-echigbo/pup.svg?branch=master)](https://travis-ci.org/andela-echigbo/pup) [![Coverage Status](https://coveralls.io/repos/github/andela-echigbo/pup/badge.svg?branch=master)](https://coveralls.io/github/andela-echigbo/pup?branch=master) [![Test Coverage](https://codeclimate.com/github/andela-echigbo/pup/badges/coverage.svg)](https://codeclimate.com/github/andela-echigbo/pup/coverage) [![Code Climate](https://codeclimate.com/github/andela-echigbo/pup/badges/gpa.svg)](https://codeclimate.com/github/andela-echigbo/pup)


**Pup** is a micro framework target built on Ruby and Rack. The motive of building this framework was not to compete with Rails, but to create my own implemtnation of the MVC framework to help me and other programmers like me(that might want to read and/or contribute to this project) understand what actually happens behind the scene in rails and other awesome MVC frameworks.

Pup is recommended for begginers who might want to work with a simpler framework, understand the besics of MVC framework and to build a non-complex application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pup

## Usage

Creating a **Pup** application is very simple, however, a few things need to be setup and a few rules adhered to. Pup follows the same folder structure as a typical rails app with all of the `model`, `view` and `controller` code packed inside of an `app` folder, configuration based code and `routing` system placed inside a `config` folder and the main database file in a db folder. [Here](https://github.com/andela-echigbo/pup-notebook) is a link to a `Note Keeping` application app built using Pup with the correct folder setup, it can be forked, cloned and edited to suit other purposes.

### Setup

In order to run a Pup app, it is expected that a `config.ru` file exists in the root directory of your project and all the needed files have been required here.

Example `config.ru` file:

* Note that the `APP_ROOT` constant is required and must point to the current file directory as the gem uses this internally to find and link folders.

```ruby
APP_ROOT ||= __dir__

require File.expand_path("../config/application", __FILE__)

PupApplication ||= NoteBook::Application.new
require_relative "config/routes.rb"

app ||= Rack::Builder.new do
  use Rack::Reloader
  use Rack::Static, urls: ["/stylesheets", "/images", "/javascripts"],
                    root: "app/assets"

  run PupApplication
end

run app

```

### Routes

The route file should be required in the config.ru file after the application has been initialized and before the rack 'run' command is called.

Example route file:

```ruby
PupApplication.routes.create do
  resources "notes"
  root "pages#index"
  get "/about", to: "pages#about"
  post "/contact", to: "pages#contact"
end

```

### Models

Pup implements a lightweight orm that makes it easy to query the database using ruby objects. It supports only sqlite3. Models are placed inside the `app/models` folder.

Example model file:

```ruby
class Note < Pup::Model
  to_table :notes
  property :title, type: :varchar, nullable: false
  property :category, type: :varchar, default: "unclassified"
  property :content, type: :text
  property :created_at, type: :datetime
  property :updated_at, type: :datetime

  create_table
end

```

### Controllers

Controllers are placed inside the `app/controllers` folder.

Example controller file:

```ruby
class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end
end

```

Note that the `ApplicationController` itself should be define in the controllers directory and it inherits from `Pup::BaseController`.

### Views

View templates are mapped to controller actions and must assume the same nomenclature as their respective actions. Erbuis is used as the templating engine and the views that are rendered are required to have the `.erb` file extension. Views are placed inside the `app/views` folder.

Example view file:

```erb
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Notes App</title>
</head>
<body>
  html content of the site here
  <%= @title %> to interpolate a variable from the controller
</body>
</html>
```
## Running the tests

Test files are placed inside the spec folder including the unit tests and the integration tests. You can run the tests from your command line client by typing `rspec spec`

## Limitation

**Pup** is still in an evolving stage, but is targeted at being one of the most used micro framework for developing simple web application for the web. However, there is still a long way to go and we are calling on you to bring it closer to it's target. The following are yet to be implemented in Pup.

* Migration - Managing your database status separately
* Executables - Scripts that can perform operations in application _(start server, run migrations, etc)_
* Supports for other templating engine
* Support for other database managment systems
* ...and more


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-echigbo/pup. This project is intended to be a safe and welcoming space for collaboration. To contribute to this work:

1. Fork it ( https://github.com/[andela-echigbo]/pup/fork )

2. Create your feature branch (`git checkout -b my-new-awesome-feature`)

3. Commit your changes (`git commit -am 'Add some awesome feature'`)

4. Push to the branch (`git push origin my-new-awesome-feature`)

5. Create a new Pull Request

6. Wait
