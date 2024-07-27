# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :set_oauth_client, only: [:signin, :callback, :client_credentials, :user, :wares, :providers, :fetch_user_profile, :fetch_organizations_data, :fetch_action_items]
  before_action :set_access_token, only: [:fetch_user_profile, :fetch_organizations_data, :fetch_action_items]

  def signin
    redirect_to @client.auth_code.authorize_url(redirect_uri: redirect_uri), allow_other_host: true
  end

  def signout
    reset_session
    session[:token_info] = nil
    redirect_to root_path
  end

  def callback
    @oauth_data = @client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
    session[:access_token] = @oauth_data.token
    session[:token_info] = {
      token: @oauth_data.token,
      expires_in: @oauth_data.expires_in,
      refresh_token: @oauth_data.refresh_token
    }
    redirect_to root_path, notice: "Successfully authenticated with the server"
  end

  def client_credentials
    @oauth_data = @client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
  end

  def token
    render plain: session[:access_token]
  end

  def wares
    render json: get_response('wares.json')
  end

  def providers
    render json: get_response('providers.json')
  end

  def fetch_user_profile
    response = @access_token.get('/api/v2/users/profile.json')
    @user_profile_data = JSON.parse(response.body)['user']
    respond_to do |format|
      format.html { render 'show_user_profile' }
      format.json { render json: @user_profile_data }
    end
  end

  def fetch_organizations_data
    response = @access_token.get('/api/v2/organizations.json')
    @organizations_data = JSON.parse(response.body)
    respond_to do |format|
      format.html { render 'show_organizations_data' }
      format.json { render json: @organizations_data }
    end
  end

  def fetch_action_items
    response = @access_token.get('/api/v2/action_items.json')
    @action_items = JSON.parse(response.body)
    respond_to do |format|
      format.html { render 'show_action_items' }
      format.json { render json: @action_items }
    end
  end

  private

  def set_oauth_client
    @client = OAuth2::Client.new(
      ENV['CLIENT_ID'], 
      ENV['CLIENT_SECRET'], 
      site: ENV['OAUTH_BASE_URL']
    )
  end

  def set_access_token
    @access_token = OAuth2::AccessToken.new(@client, session[:access_token])
  end

  def redirect_uri
    ENV['CALLBACK_URL']
  end

  def get_response(url)
    access_token = OAuth2::AccessToken.new(@client, session[:access_token])
    JSON.parse(access_token.get("/api/#{url}").body)
  end
end
