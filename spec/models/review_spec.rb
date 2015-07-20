require 'spec_helper'

describe Review do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:comment) }
end
