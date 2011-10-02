class OauthAuthorization < ActiveRecord::Base

	TimeToLive = 15.minutes

	belongs_to :user, :foreign_key => :user_uuid
	belongs_to :oauth_client

	before_create :generate_code, :generate_expires_at
	after_create  :destroy_all_conflicting_authorizations

private

	def generate_code
		self.code = ActiveSupport::SecureRandom.hex(32)
	end

	def generate_expires_at
		self.expires_at = Time.now + TimeToLive
	end

	def destroy_all_conflicting_authorizations
		OauthAuthorization.destroy_all(['id != ? and user_uuid = ? and oauth_client_id = ?', id, user_id, oauth_client_id])
	end

end
