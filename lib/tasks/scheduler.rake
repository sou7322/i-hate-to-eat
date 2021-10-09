namespace :scheduler do
  desc "動作確認用"
  task test_scheduler: :environment do
    puts "Scheduler test is works."
  end

  desc "期限切れのsuggestionを削除"
  task destroy_expied_suggestions: :environment do
    User.find_each do |user|
      Suggestion.transaction do
        user.suggestions.where("expires_at < ?", Time.zone.today).each(&:destroy!)
      end
    end
  end

  desc "ユーザーごとに当日の食事内容を新規作成"
  task create_suggestion: :environment do
    User.find_each do |user|
      meal_menus = []

      # 食材を上限4種類にしぼり提案を作成する場合
      regular = Food.prio_h.order("RANDOM()").limit(1)
      main = Food.prio_m.maindish.order("RANDOM()").limit(1)
      side = Food.prio_rm.sidedish.order("RANDOM()").limit(2)

      meal_menus.concat(regular, main, side)

      # 確定したメニューの内容をSuggestionのインスタンスとして保存
      begin
        Suggestion.transaction do
          meal_menus.each do |m|
            item = user.suggestions.new(
              food_id: m.id,
              amount: m.reference_amount,
              # target_date: "",
              target_date: Time.current.ago(1.day),
              # target_date: Time.zone.today,
              expires_at: Time.current.end_of_day
            )
  
            item.save!
          end
        end
      rescue => exception
        Rails.logger.warn "User#{user.id}: Failed to save the suggestion. Cause...'#{exception}'"
      end
    end
  end
end

# # 上限なくBMRを満たす分の提案を作成する場合
# # 食品の配列から合計カロリーを算出
# def sum_calories(foods)
#   foods.inject(0) do |sum, food|
#     sum + food.calorie * food.reference_amount
#   end
# end

# User.find_each do |user|
#   meal_menus = []

#   # ・主菜・主食をそれぞれ1つずつ追加
#   regular = Food.h_prio
#   main = Food.m_prio.maindish.order("RANDOM()").limit(1)
#   staple = Food.m_prio.staple_food.order("RANDOM()").limit(1)

#   meal_menus.concat(regular, main, staple)

#   # 合計カロリーがBMRに達するまで副菜を追加
#   # TODO: 無理矢理な計数ループ、要リファクタリング
#   bmr = user.bmr
#   loop = 0
#   while !@over_bmr && loop <= 50
#     # 重複を避けてサイドメニューを1つずつ取得
#     side = Food.where.not(id: meal_menus.map(&:id)).rm_prio.sidedish.order("RANDOM()").limit(1)
#     meal_menus.concat(side)

#     @over_bmr = sum_calories(meal_menus) > bmr
#     loop += 1
#   end

#   # 確定したメニューの内容をSuggestionのインスタンスとして保存
#   Suggestion.transaction do
#     meal_menus.each do |m|
#       item = user.suggestions.new(
#         food_id: m.id,
#         amount: m.reference_amount,
#         target_date: Time.zone.today,
#         expires_at: Time.current.end_of_day
#       )

#       item.save!
#     end
#   end
# end