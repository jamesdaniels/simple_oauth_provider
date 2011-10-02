class Oauth::AuthorizationsController < Oauth::BaseController

	def new
		raise ArgumentError unless params[:response_type] == 'code'
		@oauth_client = OauthClient.find_by_token!(params[:client_id])
		@oauth_authorization = current_user.oauth_authorizations.new(:oauth_client => @oauth_client)
	end

	def create
		@oauth_authorization = current_user.oauth_authorizations.new(params[:oauth_authorization])
		@oauth_client = @oauth_authorization.oauth_client
		if @oauth_authorization.save
			redirect_to "#{@oauth_client.callback_uri}?code=#{@oauth_authorization.code}#{"&state=#{params[:state]}" if params[:state]}"
		else
			render :action => 'new'
		end
	end

end
