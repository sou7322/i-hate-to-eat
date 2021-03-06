# frozen_string_literal: true

module Line
  class HealthSavingsReplier < Line::LinebotBase
    def self.call(user)
      new(user).call
    end

    def call
      total = savings_total
      text = textualize(total)

      reply_text(text)
    end

    private

      def initialize(user)
        @user = user
      end

      def savings_total
        @user.health_savings
      end

      def textualize(total)
        "現在の健康貯金総額\n¥#{total}"
      end
  end
end
