module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :set_invitation_token!

    def clear_token!
      self.update_column(:invitation_token, nil)
    end

    private

    def set_invitation_token!
      self.invitation_token = SecureRandom.urlsafe_base64
    end
  end
end
