require 'spec_helper'

describe User do
  it { should validate_presence_of(:device_token) }
  it { should validate_uniqueness_of(:device_token) }
end
