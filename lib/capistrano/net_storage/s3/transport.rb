require 'forwardable'

require 'capistrano/net_storage/transport/base'

require 'capistrano/net_storage/s3'

class Capistrano::NetStorage::S3::Transport < Capistrano::NetStorage::Transport::Base
  extend Forwardable
  def_delegators :broker, :check, :archive_exists?, :upload, :download, :cleanup

  private

  def broker
    @broker ||= Capistrano::NetStorage::S3.config.broker_class.new
  end
end
