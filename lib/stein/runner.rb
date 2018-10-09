
require 'singleton'

module Stein
  class Runner
    include Singleton

    def initialize
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def exec
    end
  end
end
