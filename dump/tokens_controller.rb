class Oauth::TokensController < Oauth::BaseController

	skip_before_filter :authenticate, :only => [:create, :update]

	def index
		@oauth_tokens = current_user.oauth_tokens.includes(:oauth_client)
	end

	def create
		@oauth_authorization = OauthAuthorization.find_by_code!(params[:code])
		raise ArgumentError if @oauth_authorization.oauth_client.token  != params[:client_id]
		raise ArgumentError if @oauth_authorization.oauth_client.secret != params[:client_secret]
		@oauth_token = @oauth_authorization.user.oauth_tokens.create(:oauth_client => @oauth_authorization.oauth_client)
		@oauth_authorization.destroy
		render :json => @oauth_token
	end

	def update
		# TO BE USED FOR REFRESH REQUESTS
	end

	def destroy
		current_user.oauth_tokens.find(params[:id]).destroy
		redirect_to oauth_tokens_path
	end

end
