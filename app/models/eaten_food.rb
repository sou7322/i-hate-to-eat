# frozen_string_literal: true

class EatenFood < ApplicationRecord
  # Association
  belongs_to :meal_record
  belongs_to :food

  # Validation
  validates :amount, presence: true, numericality: true
  validates :meal_record_id, uniqueness: { scope: [:food_id] }
end

# == Schema Information
#
# Table name: eaten_foods
#
#  id             :bigint           not null, primary key
#  amount         :float            default(1.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  food_id        :bigint           not null
#  meal_record_id :bigint           not null
#
# Indexes
#
#  index_eaten_foods_on_food_id                     (food_id)
#  index_eaten_foods_on_meal_record_id              (meal_record_id)
#  index_eaten_foods_on_meal_record_id_and_food_id  (meal_record_id,food_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (food_id => foods.id)
#  fk_rails_...  (meal_record_id => meal_records.id)
#
