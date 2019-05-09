require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'Scopes' do
    describe '#rentaled' do
      subject { described_class.rentaled }

      let!(:rentaled_book) { create(:book, :rentaled) }
      let!(:not_rentaled_book) { create(:book) }

      it { is_expected.to include rentaled_book }
      it { is_expected.not_to include not_rentaled_book }
    end
  end

  describe 'rented_for_a_long_time?' do
    subject { book.rented_for_a_long_time? }

    context 'when book is rentaled' do
      let(:book) { create(:book) }
      let!(:older_rental_operation) { create(:rental_operation, book: book, created_at: (Book::RENTAL_LIMIT_DAYS).days.ago) }

      it { is_expected.to eq false }
    end

    context 'when book is not rentaled' do
      let(:book) { create(:book, :rentaled) }
      context 'when last rental operation is recent' do
        let!(:recent_rental_operation) { create(:rental_operation, book: book, created_at: (Book::RENTAL_LIMIT_DAYS - 1).days.ago) }

        it { is_expected.to eq false }
      end
      context 'when last rental operation is recent' do
        let!(:older_rental_operation) { create(:rental_operation, book: book, created_at: Book::RENTAL_LIMIT_DAYS.days.ago) }

        it { is_expected.to eq true }
      end
    end
  end

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
