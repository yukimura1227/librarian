require 'rails_helper'

RSpec.describe Order, type: :model do
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
