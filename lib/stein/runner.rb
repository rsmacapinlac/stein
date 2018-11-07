require 'singleton'
require 'stein/logging'

module Stein
  class Runner
    include Singleton
    include Logging

    def initialize(*); end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def pre_exec; end
    def exec; end
    def post_exec; end

    def loader
      pre_exec
      exec
      post_exec
    end

  end
end
