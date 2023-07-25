require 'capistrano/net_storage/s3/config'
require 'capistrano/net_storage/s3/transport'

module Capistrano
  module NetStorage
    class S3
      class << self
        attr_reader :config

        def setup!(config:)
          @config = config
        end
      end
    end
  end
end

Capistrano::NetStorage::S3.setup!(config: Capistrano::NetStorage::S3::Config.new)
