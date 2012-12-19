require 'capistrano'
require 'capistrano-vexxhost'
require 'bundler/capistrano'

# Account Settings
set :user, "ffullenk"
set :password, "gnuubuntu12"
set :domain, "georoom.ffullenk.com"
set :mount_path, "/georoom"
set :application, "georoom"

set :scm, :git
set :repository, "git@github.com:ffullenk/georoon.git"