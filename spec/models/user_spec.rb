# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }

    it { should define_enum_for(:status).with_values(active: 'active', banned: 'banned')
         .with_default(:active).backed_by_column_of_type(:string) }

    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end
end
