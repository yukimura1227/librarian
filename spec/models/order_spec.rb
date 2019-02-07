require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '.wait_for_purchase_a_long_time' do
    subject { described_class.wait_for_purchase_a_long_time }
    let!(:old_order) { create(:order, order_time: 8.days.ago) }
    let!(:new_order) { create(:order, order_time: 7.days.ago) }

    it '7日前より古い注文が取得されること' do
      is_expected.to include old_order
    end

    it '7日前以内の注文は取得されないこと' do
      is_expected.not_to include new_order
    end
  end
  describe '#purchase' do
    subject(:purchase) { order.purchase }
    let(:order) { create(:order) }

    it 'state change to purchased' do
      expect { purchase }.to change { order.state }
        .from('order_purchase_waiting')
        .to('order_purchased')
    end

    it 'crete a book' do
      expect { purchase }.to change { Book.count }.by(1)
    end
  end
end
