[![Build Status](https://secure.travis-ci.org/jrichardlai/taskrabbit.png?branch=master)](http://travis-ci.org/jrichardlai/taskrabbit)

# TaskRabbit Ruby Gem

Ruby wrapper for TaskRabbit API.

## Installation

    gem install taskrabbit

Or in a Gemfile:

    gem 'taskrabbit'


## Usage Example

### Configuration

In an initializer file.

    Taskrabbit.configure do |config|
      config.api_secret = 'your-client-secret'
      config.api_key    = 'your-client-key'
      config.base_uri   = 'https://sandbox.com'
      config.endpoint   = 'api/v2'
    end

Available configuration options:

   * api_secret: client secret that has been given to you by TaskRabbit
   * api_key: client key that has been given by TaskRabbit
   * base_uri: uri of the server (not mandatory, default to https://www.taskrabbit.com) 
   * endpoint: endpoint (not mandatory, default to api/v1)

## Task

### use the API client

    tr = Taskrabbit::Api.new
    
or with a user token returned by TaskRabbit.

    tr = Taskrabbit::Api.new(user_token)

### Get the list of all the tasks

    tr = Taskrabbit::Api.new
    # to get the /tasks
    tasks = tr.tasks.all
    # fetch the first task
    tasks.first
    
    tasks.all(:reload => true) # => will redo the query

### Find a task

    tr = Taskrabbit::Api.new
    t = tr.tasks.find(31231) # This actually wont do the request

To request the API:

    t.fetch # force fetching

or simply access a property:

    t.name # will do the query

### Find the tasks of an user

    tr.users.find(user_id).tasks

### Create a task

    tr = Taskrabbit::Api.new(user_token)
    task = tr.tasks.create({:named_price => 32, :name => 'Ikea'})

or 

    task = tr.tasks.new({:named_price => 32, :name => 'Ikea'})
    task.save

### Update a task

    task = tr.tasks.find(32121)
    task.named_price = 45
    task.save

### Error for tasks creation or update

    tr = Taskrabbit::Api.new(user_token)
    task = tr.tasks.new
    unless task.save
      task.error # => "Task title can't be blank, \nAmount you are willing to pay is not a number"
      task.errors # => { "messages" => ["Task title can't be blank", "Amount you are willing to pay is not a number"],
                         "fields" => [["name","can't be blank"], ["named_price","is not a number"]] }
    end

### Redirect

In some case TaskRabbit will return an url which should be used for further operations (i.e: when the user doesn't have a credit card).

    tr = Taskrabbit::Api.new(user_token)
    task = tr.tasks.new
    unless task.save
      if task.redirect?
        task.redirect_url #=> 'http://www.taskrabbit.com/somepath'
      end
    end

## User account

    tr = Taskrabbit::Api.new(user_token)
    tr.account # => Taskrabbit::User object

    tr.account.tasks # => List of tasks
    tr.account.tasks.create(some_params)

## Cities

### Get list of cities

    tr.cities.each do |city|
      city.name
    end

### Find a city using the id

    tr.cities.find(3).name # => "SF Bay Area"

### More informations

More informations: http://taskrabbit.github.com

## TODO

Add:

- Picture and sound upload
- Pages