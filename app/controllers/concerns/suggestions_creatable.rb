# frozen_string_literal: true

module SuggestionsCreatable
  extend ActiveSupport::Concern

  def create_suggestions(user)
    # 食材を上限4種類にしぼり提案を作成する場合
    meal_menus = get_meal_menus

    # 確定したメニューの内容をSuggestionのインスタンスとして保存
    begin
      Suggestion.transaction do
        meal_menus.each do |m|
          item = user.suggestions.new(
            food_id: m.id,
            amount: m.reference_amount,
            target_date: Time.zone.today,
            expires_at: Time.current.end_of_day
          )

          item.save!
        end
      end
    rescue StandardError => e
      Rails.logger.warn "User#{user.id}: Failed to save the suggestion. Cause...'#{e}'"
    end
  end

  private

    def get_meal_menus
      foods = []
      foods.concat(get_regular_food, get_main_dish, get_side_dishes)
    end

    def get_regular_food
      Food.prio_h.order("RANDOM()").limit(1)
    end

    def get_main_dish
      Food.prio_m.maindish.order("RANDOM()").limit(1)
    end

    def get_side_dishes
      Food.prio_rm.sidedish.order("RANDOM()").limit(2)
    end
end