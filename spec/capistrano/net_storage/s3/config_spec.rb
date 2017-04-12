require 'spec_helper'

describe Capistrano::NetStorage::S3::Config do
  let(:config) { Capistrano::NetStorage::S3::Config.new }
  let(:net_storage) { Capistrano::NetStorage.config }

  before :context do
    env = Capistrano::Configuration.env
    env.set :net_storage_transport, Capistrano::NetStorage::S3::Transport
  end

  after :context do
    Capistrano::Configuration.reset!
  end

  describe 'Configuration params' do
    it 'Default parameters' do
      expect(config.broker).to be_an_instance_of Capistrano::NetStorage::S3::Broker::AwsCLI
      expect { config.bucket_url }.to raise_error(Capistrano::NetStorage::S3::Error)
      expect(config.max_retry).to eq 3

      # AWS config variables
      expect(config.aws_access_key_id).to eq ENV['AWS_ACCESS_KEY_ID']
      expect(config.aws_secret_access_key).to eq ENV['AWS_SECRET_ACCESS_KEY']
      expect(config.aws_session_token).to eq ENV['AWS_SESSION_TOKEN']
      expect(config.aws_region).to eq ENV['AWS_DEFAULT_REGION']
      expect(config.aws_profile).to eq ENV['AWS_DEFAULT_PROFILE']
      expect(config.aws_config_file).to eq ENV['AWS_CONFIG_FILE']
      expect(config.aws_environments).to be_an_instance_of Hash
    end

    it 'Customized parameters' do
      env = Capistrano::Configuration.env
      {
        net_storage_s3_aws_access_key_id: 'AKI_TEST',
        net_storage_s3_aws_secret_access_key: 'test-secret',
        net_storage_s3_aws_session_token: 'test-token',
        net_storage_s3_aws_region: 'test-region',
        net_storage_s3_aws_profile: 'test-profile',
        net_storage_s3_aws_config_file: '/path/to/aws/config',
        net_storage_s3_bucket: 'test-bucket',
        net_storage_s3_archives_directory: 'archives',
        net_storage_s3_max_retry: 5,
        current_revision: 'test-revision',
      }.each { |k, v| env.set k, v }

      expect(config.bucket_url.to_s).to eq 's3://test-bucket'
      expect(config.archives_url.to_s).to eq 's3://test-bucket/archives/'
      expect(config.archive_url.to_s).to eq "s3://test-bucket/archives/test-revision.#{net_storage.archive_suffix}"
      expect(config.max_retry).to eq 5

      # AWS config variables
      expect(config.aws_access_key_id).to eq 'AKI_TEST'
      expect(config.aws_secret_access_key).to eq 'test-secret'
      expect(config.aws_session_token).to eq 'test-token'
      expect(config.aws_region).to eq 'test-region'
      expect(config.aws_profile).to eq 'test-profile'
      expect(config.aws_config_file).to eq '/path/to/aws/config'
      expect(config.aws_environments).to eq(
        aws_config_file: '/path/to/aws/config',
        aws_default_profile: 'test-profile',
        aws_default_region: 'test-region',
        aws_access_key_id: 'AKI_TEST',
        aws_secret_access_key: 'test-secret',
        aws_session_token: 'test-token',
      )
    end
  end
end
