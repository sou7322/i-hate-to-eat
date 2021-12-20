# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoodCategory, type: :model do
end

# == Schema Information
#
# Table name: food_categories
#
#  id         :bigint           not null, primary key
#  name       :string           default("noname"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
