require 'spec_helper'

describe Photo, "Validations" do
  it { should validate_presence_of(:image) }
end

describe Photo, "Associations" do
	it { should belong_to(:event) }
end
