require 'spec_helper'

require 'capistrano/net_storage/s3/config'

describe Capistrano::NetStorage::S3::Config do
  let(:config) { Capistrano::NetStorage::S3::Config.new }
  let(:ns_config) { Capistrano::NetStorage.config }
  let(:env) { Capistrano::Configuration.env } # Capistrano::NetStorage::Config fetches from global env

  def clear_aws_env!
    %w[
      AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY
      AWS_SESSION_TOKEN
      AWS_DEFAULT_REGION
      AWS_DEFAULT_PROFILE
      AWS_CONFIG_FILE
    ].each do |name|
      ENV.delete(name)
    end
  end

  before do
    clear_aws_env!
    Capistrano::Configuration.reset!

    env.instance_eval(&capfile)
    invoke! 'load:defaults'
  end

  describe 'configuration' do
    context 'with default settings' do
      let(:capfile) do
        -> (_env) {
          set :application, 'api'
          set :deploy_to, '/path/to/deploy'
          role :web, %w(web1 web2)
          role :db,  %w(db1)

          require 'capistrano/net_storage/s3/transport'
          set :net_storage_transport, Capistrano::NetStorage::S3::Transport
        }
      end

      before do
        ENV['AWS_ACCESS_KEY_ID'] = 'aki'
        ENV['AWS_SECRET_ACCESS_KEY'] = 'sak'
        ENV['AWS_SESSION_TOKEN'] = 'st'
        ENV['AWS_DEFAULT_REGION'] = 'dr'
        ENV['AWS_DEFAULT_PROFILE'] = 'dp'
        ENV['AWS_CONFIG_FILE'] = 'cf'
      end

      it 'yields default parameters' do
        expect(config.broker_class).to be Capistrano::NetStorage::S3::Broker::AwsCLI
        expect { config.bucket }.to raise_error(ArgumentError)
      end

      it 'yields AWS variable from ENV' do
        expect(config.aws_environments).to eq(
          aws_access_key_id: 'aki',
          aws_secret_access_key: 'sak',
          aws_session_token: 'st',
          aws_default_region: 'dr',
          aws_default_profile: 'dp',
          aws_config_file: 'cf'
        )
      end
    end

    context 'with customized parameters' do
      let(:capfile) do
        -> (_env) {
          set :application, 'api'
          set :deploy_to, '/path/to/deploy'
          role :web, %w(web1 web2)
          role :db,  %w(db1)

          set :net_storage_transport, Capistrano::NetStorage::S3::Transport

          set :net_storage_s3_aws_access_key_id, 'aki-from-cap'
          set :net_storage_s3_aws_secret_access_key, 'sak-from-cap'
          set :net_storage_s3_aws_session_token, 'st-from-cap'
          set :net_storage_s3_aws_region, 'dr-from-cap'
          set :net_storage_s3_aws_profile, 'dp-from-cap'
          set :net_storage_s3_aws_config_file, 'cf-from-cap'

          set :net_storage_s3_bucket, 'test-bucket'
          set :net_storage_s3_archives_directory, 'archives'

        }
      end

      before do
        # In real deployment flow, this is set by Capistrano::NetStorage
        set :current_revision, 'test-revision'
      end

      it 'Customized parameters' do
        expect(config.bucket).to eq 'test-bucket'
        expect(config.archives_url.to_s).to eq 's3://test-bucket/archives/'
        expect(config.archive_url.to_s).to eq "s3://test-bucket/archives/test-revision.#{ns_config.archive_suffix}"
      end

        # AWS config variables
      it 'yields AWS parameters from config' do
        expect(config.aws_environments).to eq(
          aws_access_key_id: 'aki-from-cap',
          aws_secret_access_key: 'sak-from-cap',
          aws_session_token: 'st-from-cap',
          aws_default_region: 'dr-from-cap',
          aws_default_profile: 'dp-from-cap',
          aws_config_file: 'cf-from-cap',
        )
      end
    end
  end
end
