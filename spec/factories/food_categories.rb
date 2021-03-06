# frozen_string_literal: true

FactoryBot.define do
  factory :food_category do
    sequence(:name, "test_category_0")
  end
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
