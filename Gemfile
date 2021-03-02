# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
gem 'sinatra'
gem "activerecord", "~> 5.2.4", :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'sinatra-websocket'
gem 'rake'
gem 'require_all'
gem 'thin'

group :development do
    gem 'pry'
    gem 'sqlite3', '~>1.3.6'
end

group :production do
    gem 'pg'
    gem 'activerecord-postgresql-adapter'
end