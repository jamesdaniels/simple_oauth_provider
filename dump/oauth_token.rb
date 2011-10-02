class OauthToken < ActiveRecord::Base

	TimeToLive = 30.days

	belongs_to :user, :foreign_key => :user_uuid
	belongs_to :oauth_client

	before_create :generate_access_token, :generate_refresh_token, :generate_expires_at
	after_create  :destroy_all_conflicting_tokens

	def as_json(options = {})
		{:access_token => access_token, :token_type => 'bearer', :expires_in => (expires_at - Time.now).to_i, :refresh_token => refresh_token}
	end

private

	def generate_access_token
		self.access_token = ActiveSupport::SecureRandom.hex(32)
	end

	def generate_refresh_token
		self.refresh_token = ActiveSupport::SecureRandom.hex(32)
	end

	def generate_expires_at
		self.expires_at = Time.now + TimeToLive
	end

	def destroy_all_conflicting_tokens
		OauthToken.destroy_all(['id != ? and user_uuid = ? and oauth_client_id = ?', id, user_id, oauth_client_id])
	end

end
