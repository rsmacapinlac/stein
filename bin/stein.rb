#!/usr/bin/env ruby

require 'bundler/setup'
require './lib/stein'
require 'optparse'

# stein.rb --robot=boogienet-infinitewp.rb
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: stein.rb --robot=robot-file.rb"
  opts.on("-rROBOT_FILE","--robot=ROBOT_FILE", "robot file") do |robot_file|
    options[:robot_file] = robot_file
  end
  opts.on("-h", "--help", "Print this help") do
    puts opts
    exit
  end
end.parse!

# raise required items
raise OptionParser::MissingArgument if options[:robot_file].nil?

app = Stein::Application.instance
puts app

load options[:robot_file]
