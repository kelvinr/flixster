module Tokenable
  extend ActiveSupport::Concern

private

  def generate_token(prefix=nil)
    self.send("#{prefix}token=", SecureRandom.urlsafe_base64)
  end
end
