require 'uri'

require 'capistrano/net_storage/s3/broker/aws_cli'

class Capistrano::NetStorage::S3
  class Config
    def broker_class
      case fetch(:net_storage_s3_broker, :aws_cli)
      when :aws_cli
        Broker::AwsCLI
      else
        raise ArgumentError, "No broker defined! #{fetch(:net_storage_s3_broker)}"
      end
    end

    def aws_environments
      {
        aws_config_file: aws_config_file,
        aws_default_profile: aws_profile,
        aws_default_region: aws_region,
        aws_access_key_id: aws_access_key_id,
        aws_secret_access_key: aws_secret_access_key,
        aws_session_token: aws_session_token,
      }.compact
    end

    def bucket
      fetch(:net_storage_s3_bucket, -> { raise ArgumentError, ':net_storage_s3_bucket is not configured!' })
    end

    def archives_url
      URI.parse("s3://#{bucket}") + archives_directory
    end

    def archive_url
      revision = fetch(:current_revision)
      raise ArgumentError, ':current_revision is not set! Your deployment flow might be buggy.' unless revision

      archives_url + "#{revision}.#{Capistrano::NetStorage.config.archive_file_extension}"
    end

    def s3_keep_releases
      fetch(:net_storage_s3_keep_releases, fetch(:keep_releases))
    end

    private

    def archives_directory
      directory = fetch(:net_storage_s3_archives_directory, '/')

      # Make it absolute directory path from root
      directory = "#{directory}/" unless directory.end_with?('/')
      directory = "/#{directory}" unless directory.start_with?('/')

      directory
    end

    def aws_access_key_id
      fetch(:net_storage_s3_aws_access_key_id, ENV['AWS_ACCESS_KEY_ID'])
    end

    def aws_secret_access_key
      fetch(:net_storage_s3_aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])
    end

    def aws_session_token
      fetch(:net_storage_s3_aws_session_token, ENV['AWS_SESSION_TOKEN'])
    end

    def aws_region
      fetch(:net_storage_s3_aws_region, ENV['AWS_DEFAULT_REGION'])
    end

    def aws_profile
      fetch(:net_storage_s3_aws_profile, ENV['AWS_DEFAULT_PROFILE'])
    end

    def aws_config_file
      fetch(:net_storage_s3_aws_config_file, ENV['AWS_CONFIG_FILE'])
    end
  end
end
