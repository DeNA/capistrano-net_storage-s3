require 'uri'

require 'capistrano/net_storage/s3/base'
require 'capistrano/net_storage/s3/error'
require 'capistrano/net_storage/s3/broker/aws_cli'

class Capistrano::NetStorage::S3
  class Config
    # Broker object for transport operations
    # @return [Capistrano::NetStorage::S3::Broker::Base]
    def broker
      @broker ||= begin
        case fetch(:net_storage_s3_broker, :aws_cli)
        when :aws_cli
          Broker::AwsCLI.new
        else
          raise Capistrano::NetStorage::S3::Error, "No broker defined! #{fetch(:net_storage_s3_broker)}"
        end
      end
    end

    # AWS configurations

    # @return [String] AWS Access Key ID
    def aws_access_key_id
      @aws_access_key_id ||= fetch(:net_storage_s3_aws_access_key_id, ENV['AWS_ACCESS_KEY_ID'])
    end

    # @return [String] AWS Secret Access Key
    def aws_secret_access_key
      @aws_secret_access_key ||= fetch(:net_storage_s3_aws_secret_access_key)
      @aws_secret_access_key ||= ENV['AWS_SECRET_ACCESS_KEY']
    end

    # @return [String] AWS Session Token
    def aws_session_token
      @aws_session_token ||= fetch(:net_storage_s3_aws_session_token, ENV['AWS_SESSION_TOKEN'])
    end

    # @return [String] AWS Region
    def aws_region
      @aws_region ||= fetch(:net_storage_s3_aws_region, ENV['AWS_DEFAULT_REGION'])
    end

    # @return [String] AWS Profile
    def aws_profile
      @aws_profile ||= fetch(:net_storage_s3_aws_profile, ENV['AWS_DEFAULT_PROFILE'])
    end

    # AWS Config File
    def aws_config_file
      @aws_config_file ||= fetch(:net_storage_s3_aws_config_file, ENV['AWS_CONFIG_FILE'])
    end

    # @return [Hash] AWS environment variables
    def aws_environments
      @aws_environments ||= begin
        environments = {}
        environments[:aws_config_file]       = aws_config_file       if aws_config_file
        environments[:aws_default_profile]   = aws_profile           if aws_profile
        environments[:aws_default_region]    = aws_region            if aws_region
        environments[:aws_access_key_id]     = aws_access_key_id     if aws_access_key_id
        environments[:aws_secret_access_key] = aws_secret_access_key if aws_secret_access_key
        environments[:aws_session_token]     = aws_session_token     if aws_session_token
        environments
      end
    end

    # S3 bucket name via which one transports application archives
    # @return [String]
    def bucket
      @bucket ||= begin
        unless bucket = fetch(:net_storage_s3_bucket)
          raise Capistrano::NetStorage::S3::Error, ':net_storage_s3_bucket is not configured!'
        end
        bucket
      end
    end

    # S3 bucket URL via which one transports application archives
    # @return [URI::Generic]
    def bucket_url
      @bucket_url ||= URI.parse("s3://#{bucket}")
    end

    # Directory path on S3 bucket for application archives
    # @return [String]
    def archives_directory
      # append '/' in case missing
      @archives_directory ||= begin
        dir = fetch(:net_storage_s3_archives_directory)
        dir.sub(%r{[^/]\Z}, '\&/') if dir
      end
    end

    # S3 URL which contains application archives
    # @return [URI::Generic]
    def archives_url
      @archives_url ||= begin
        if archives_directory
          bucket_url + archives_directory
        else
          bucket_url
        end
      end
    end

    # S3 URL of the application archive for current deployment
    # @return [URI::Generic]
    def archive_url
      @archive_url ||= begin
        unless revision = fetch(:current_revision)
          raise Capistrano::NetStorage::Error, ':current_revision is not set!'
        end
        archive_file = "#{revision}.#{Capistrano::NetStorage.config.archive_suffix}"
        archives_url + archive_file
      end
    end

    # Max retrial number for S3 operations
    # @return [Fixnum]
    def max_retry
      @max_retry ||= fetch(:net_storage_s3_max_retry, 3)
    end

    # Number to keep archives on S3
    # @return [Fixnum]
    def s3_keep_releases
      @s3_keep_releases ||= fetch(:net_storage_s3_keep_releases, fetch(:keep_releases, 5))
    end
  end
end
