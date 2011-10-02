class Oauth::ClientsController < Oauth::BaseController

	def index
		@oauth_clients = current_user.oauth_clients
	end

	def show
		@oauth_client = current_user.oauth_clients.find(params[:id])
	end

	def edit
		@oauth_client = current_user.oauth_clients.find(params[:id])
	end

	def update
		@oauth_client = current_user.oauth_clients.find(params[:id])
		if @oauth_client.update_attributes(params[:oauth_client])
			redirect_to oauth_clients_path
		else
			render :action => 'edit'
		end
	end

	def new
		@oauth_client = current_user.oauth_clients.new
	end

	def create
		@oauth_client = current_user.oauth_clients.new(params[:oauth_client])
		if @oauth_client.save
			redirect_to oauth_client_path(@oauth_client)
		else
			render :action => 'new'
		end
	end

	def destroy
		current_user.oauth_clients.find(params[:id]).destroy
		redirect_to oauth_clients_path
	end

end
