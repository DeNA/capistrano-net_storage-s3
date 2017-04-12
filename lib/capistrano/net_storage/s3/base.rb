require 'forwardable'

module Capistrano
  module NetStorage
    class S3
      class << self
        attr_reader :config

        extend Forwardable
        def_delegator :config, :broker
      end

      def self.setup!(params)
        @config = params[:config]
      end
    end
  end
end
