# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relations' do
    it { is_expected.to have_many(:api_keys) }
    it { is_expected.to have_many(:forms) }
  end
end
