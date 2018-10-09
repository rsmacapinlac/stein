
require 'singleton'

module Stein
  class Runner
    include Singleton

    def initialize
      puts 'Stein::Runner initialized'
    end

    def exec

    end
  end
end
