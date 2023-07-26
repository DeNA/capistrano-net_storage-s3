require 'retryable'

require 'capistrano/net_storage/transport/base'

# NOTE: Broker is inherited from Transport
module Capistrano
  module NetStorage
    class S3
      module Broker
        class AwsCLI < Capistrano::NetStorage::Transport::Base
          # These values are intentionally separated from config and fixed.
          # If you have trouble with these defaults for 10^2 ~ 10^3 servers, please contact us on GitHub.
          JITTER_DURATION_TO_DOWNLOAD = 4.0
          MAX_RETRY = 3 # TODO: We need to rewrite this for large-scale AWS S3 stability
          KEEP_FILE = '.keep'

          def check
            config = Capistrano::NetStorage::S3.config

            # We check both read and write permissions with aws s3 command
            run_locally_with_aws_env do
              unless test :aws, 's3', 'ls', config.archives_url
                keep = Tempfile.create.path
                execute :aws, 's3', 'cp', keep, config.archives_url + KEEP_FILE
              end
            end
          end

          def archive_exists?
            config = Capistrano::NetStorage::S3.config

            run_locally_with_aws_env do
              test :aws, 's3', 'ls', config.archive_url
            end
          end

          def upload
            config = Capistrano::NetStorage::S3.config
            ns_config = Capistrano::NetStorage.config

            run_locally_with_aws_env do
              execute :aws, 's3', 'cp', '--no-progress', ns_config.local_archive_path, config.archive_url
            end
          end

          def download
            config = Capistrano::NetStorage::S3.config
            ns_config = Capistrano::NetStorage.config

            on release_roles(:all), in: :groups, limit: ns_config.max_parallels do
              Retryable.retryable(tries: MAX_RETRY, sleep: 0.1) do
                within releases_path do
                  with(config.aws_environments) do
                    sleep Random.rand(JITTER_DURATION_TO_DOWNLOAD)
                    execute :aws, 's3', 'cp', '--no-progress', config.archive_url, ns_config.archive_path
                  end
                end
              end
            end
          end

          def cleanup
            config = Capistrano::NetStorage::S3.config
            ns_config = Capistrano::NetStorage.config

            files = run_locally_with_aws_env do
              capture :aws, 's3', 'ls', config.archives_url
            end.lines.sort.map { |line| line.chomp.split(' ').last }
            releases = files - [KEEP_FILE]

            if releases.count > ns_config.keep_remote_archives
              run_locally_with_aws_env do
                info "Keeping #{ns_config.keep_remote_archives} of #{releases.count} in #{config.archives_url}"
                (releases - releases.last(ns_config.keep_remote_archives)).each do |release|
                  execute :aws, 's3', 'rm', config.archives_url + release
                end
              end
            else
              run_locally do
                info "No old archives (keeping newest #{ns_config.keep_remote_archives}) in #{config.archives_url}"
              end
            end
          end

          private

          def run_locally_with_aws_env(&block)
            config = Capistrano::NetStorage::S3.config

            run_locally do
              with(config.aws_environments) do
                instance_eval(&block)
              end
            end
          end
        end
      end
    end
  end
end
