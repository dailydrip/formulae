# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Form, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:application_id) }
    it { is_expected.to respond_to(:completion_content) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:application) }
    it { is_expected.to have_many(:questions).through(:sections) }
    it { is_expected.to have_many(:questions) }
  end
end
