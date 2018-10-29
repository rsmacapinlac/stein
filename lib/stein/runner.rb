
require 'singleton'
require 'stein/logging'
require 'stein/config'

module Stein
  class Runner
    include Singleton
    include Logging

    def initialize
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def exec; end
  end
end
