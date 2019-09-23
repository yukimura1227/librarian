require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#slack_name' do
    let(:user) { create(:user, email: 'hoge.fuga@example.com') }
    let!(:slack_member) { create(:slack_member, user_id: user.id) }

    subject { user.slack_name }

    it 'take name from eamil' do
      is_expected.to eq "@#{slack_member.slack_id}"
    end
  end
end
