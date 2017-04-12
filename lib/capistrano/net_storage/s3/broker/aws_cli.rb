require 'retryable'

require 'capistrano/net_storage/s3/base'
require 'capistrano/net_storage/s3/broker/base'

class Capistrano::NetStorage::S3::Broker::AwsCLI < Capistrano::NetStorage::S3::Broker::Base
  def check
    execute_aws_s3('ls', config.bucket_url)
  end

  def find_uploaded
    if capture_aws_s3('ls', config.archive_url)
      set :net_storage_uploaded_archive, true
    end
  rescue SSHKit::Runner::ExecuteError
    c = config
    on :local do
      info "Archive is not found on #{c.archive_url}"
    end
  end

  def upload
    c  = config
    ns = net_storage
    Retryable.retryable(tries: c.max_retry, sleep: 0.1) do
      execute_aws_s3('cp', ns.local_archive_path, c.archive_url)
    end
  end

  def download
    c  = config
    ns = net_storage
    on ns.servers, in: :groups, limit: ns.max_parallels do
      Retryable.retryable(tries: c.max_retry, sleep: 0.1) do
        within releases_path do
          with(c.aws_environments) do
            execute :aws, 's3', 'cp', c.archive_url, ns.archive_path
          end
        end
      end
    end
  end

  private

  def execute_aws_s3(cmd, *args)
    c = config
    on :local do
      with(c.aws_environments) do
        execute :aws, 's3', cmd, *args
      end
    end
  end

  def capture_aws_s3(cmd, *args)
    c = config
    on :local do
      with(c.aws_environments) do
        capture :aws, 's3', cmd, *args
      end
    end
  end
end
