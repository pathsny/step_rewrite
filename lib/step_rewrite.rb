require 'rubygems'
require 'parse_tree'
require 'parse_tree_extensions'
require 'Ruby2Ruby'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "step_rewrite/rewriter"
require 'step_rewrite/step_rewrite'
