# frozen_string_literal: true

module SuggestionsDestroyable
  extend ActiveSupport::Concern

  def destroy_suggestions_all(user)
    suggestions = user.suggestions.for_today
    return render404(nil, "Suggestionが存在しません") if suggestions.blank?

    begin
      Suggestion.transaction do
        suggestions.each(&:destroy!)
      end
    rescue => e
      Rails.logger.error "User#{user.id}: Failed to create meal record. Cause...'#{e}'"
      notice_to_admin("Suggestionの削除に失敗")
    end
  end
end
