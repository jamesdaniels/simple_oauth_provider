class OauthClient < ActiveRecord::Base

	validates :name, :callback_uri, :uniqueness => true, :presence => true

	has_many :oauth_tokens,         :dependent => :destroy
	has_many :oauth_authorizations, :dependent => :destroy

	belongs_to :user, :foreign_key => :user_uuid

	before_create :generate_secret, :generate_token

private

	def generate_secret
		self.secret = ActiveSupport::SecureRandom.hex(32)
	end

	def generate_token
		self.token = ActiveSupport::SecureRandom.hex(32)
	end

end
