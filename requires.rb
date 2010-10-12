ROOT = File.expand_path("..", __FILE__)
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'parse_tree_extensions'
require "#{ROOT}/step_rewrite"
require "#{ROOT}/utils"
