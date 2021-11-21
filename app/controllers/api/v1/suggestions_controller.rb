# frozen_string_literal: true

module Api
  module V1
    class SuggestionsController < Api::V1::BaseController
      include SuggestionsDestroyable

      def show
        foods = current_user.suggested_foods
        amt_pfc = current_user.set_attributes_for_pfc[:amt]

        if foods.present?
          total = get_intake_total(foods)
          achv = get_achievement(total, current_user.bmr, amt_pfc,
                                 current_user.dietary_reference_intake)

          render json: { meals: foods, total: total, achv: achv }
        else
          head :not_found
        end
      end

      def destroy
        if destroy_suggestions_all(current_user)
          head :ok
        else
          render400(nil, '食事内容の削除に失敗しました')
        end
      end

      private

        def get_intake_total(foods)
          total = NutritionTotal.new
          total.calc_intake_total(foods)
        end

        def get_achievement(total, bmr, pfc, dri)
          achv = IntakeAchievement.new
          achv.calc_intake_achievement(total, bmr, pfc, dri)
        end
    end
  end
end
