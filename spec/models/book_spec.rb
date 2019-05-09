require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'rentaled?' do
    subject { book.rentaled? }

    context 'when user_id is null' do
      let(:book) { create(:book) }

      it { is_expected.to eq false }
    end

    context 'when user_id is not null' do
      let(:book) { create(:book, :rentaled) }

      it { is_expected.to eq true }
    end
  end
  describe 'rentaled_by?' do
    subject { book.rentaled_by?(user) }

    context 'when book.user is same to argument' do
      let(:book) { create(:book, :rentaled) }
      let(:user) { book.user }

      it { is_expected.to eq true }
    end

    context 'when user_id is not null' do
      let(:book) { create(:book, :rentaled) }
      let(:user) { create(:user) }

      it { is_expected.to eq false }
    end
  end
end
