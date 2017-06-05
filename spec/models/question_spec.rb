# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:key) }
    it { is_expected.to respond_to(:label) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:hidden) }
    it { is_expected.to respond_to(:question_type) }
    it { is_expected.to respond_to(:order) }
    it { is_expected.to respond_to(:required) }
    it { is_expected.to respond_to(:placeholder) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:section) }
    it { is_expected.to have_many(:question_submissions) }
    it { is_expected.to have_many(:choices) }
    it { is_expected.to have_one(:question_dependency) }
  end
end
