# frozen_string_literal: true

class IntakeAchievement
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Attributes
  attribute :calorie, :float, default: 0.0
  attribute :protein, :float, default: 0.0
  attribute :fat, :float, default: 0.0
  attribute :carbohydrate, :float, default: 0.0
  attribute :biotin, :float, default: 0.0
  attribute :calcium, :float, default: 0.0
  attribute :chromium, :float, default: 0.0
  attribute :copper, :float, default: 0.0
  attribute :folate, :float, default: 0.0
  attribute :iodine, :float, default: 0.0
  attribute :iron, :float, default: 0.0
  attribute :magnesium, :float, default: 0.0
  attribute :manganese, :float, default: 0.0
  attribute :molybdenum, :float, default: 0.0
  attribute :niacin, :float, default: 0.0
  attribute :pantothenic_acid, :float, default: 0.0
  attribute :phosphorus, :float, default: 0.0
  attribute :potassium, :float, default: 0.0
  attribute :selenium, :float, default: 0.0
  attribute :vitamin_a, :float, default: 0.0
  attribute :vitamin_b1, :float, default: 0.0
  attribute :vitamin_b12, :float, default: 0.0
  attribute :vitamin_b2, :float, default: 0.0
  attribute :vitamin_b6, :float, default: 0.0
  attribute :vitamin_c, :float, default: 0.0
  attribute :vitamin_d, :float, default: 0.0
  attribute :vitamin_e, :float, default: 0.0
  attribute :vitamin_k, :float, default: 0.0
  attribute :zinc, :float, default: 0.0

  # Callback
  define_model_callbacks :save
  before_save :attr_validation

  # Validation
  with_options presence: true, numericality: true do
    validates :biotin
    validates :calcium
    validates :calorie
    validates :carbohydrate
    validates :chromium
    validates :copper
    validates :fat
    validates :folate
    validates :iodine
    validates :iron
    validates :magnesium
    validates :manganese
    validates :molybdenum
    validates :niacin
    validates :pantothenic_acid
    validates :phosphorus
    validates :potassium
    validates :protein
    validates :selenium
    validates :vitamin_a
    validates :vitamin_b1
    validates :vitamin_b12
    validates :vitamin_b2
    validates :vitamin_b6
    validates :vitamin_c
    validates :vitamin_d
    validates :vitamin_e
    validates :vitamin_k
    validates :zinc
  end

  # Class method
  def self.call(total, bmr, pfc, dri)
    new.calc_intake_achievement(total, bmr, pfc, dri)
  end

  # Instance method
  def calc_intake_achievement(total, bmr, pfc, dri)
    params = attributes
    params.each_key do |k|
      params[k] = case k
                  when "calorie"
                    (total[k] / bmr * 100).floor
                  when "protein", "fat", "carbohydrate"
                    (total[k] / pfc[k.to_sym] * 100).floor
                  else
                    (total[k] / dri[k] * 100).floor
                  end
    end

    self.attributes = params
  end

  private

    def attr_validation
      valid?
    end
end
