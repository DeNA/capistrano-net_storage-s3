require 'spec_helper'

describe Capistrano::NetStorage::S3 do
  it 'has a version number' do
    expect(Capistrano::NetStorage::S3::VERSION).not_to be nil
  end
end
