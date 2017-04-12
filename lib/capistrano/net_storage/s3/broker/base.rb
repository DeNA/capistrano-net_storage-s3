require 'capistrano/net_storage/s3/base'

class Capistrano::NetStorage::S3
  module Broker
    # @abstract
    class Base
      # @abstract
      def check
        raise NotImplementedError
      end

      # @abstract
      def find_uploaded
        raise NotImplementedError
      end

      # @abstract
      def upload
        raise NotImplementedError
      end

      # @abstract
      def download
        raise NotImplementedError
      end

      private

      def config
        Capistrano::NetStorage::S3.config
      end

      def net_storage
        Capistrano::NetStorage.config
      end
    end
  end
end
