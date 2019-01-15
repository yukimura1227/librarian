require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#slack_name' do
    let(:user) { create(:user, email: 'hoge.fuga@example.com') }

    subject { user.slack_name }

    it 'take name from eamil' do
      is_expected.to eq 'hoge.fuga'
    end
  end
end
