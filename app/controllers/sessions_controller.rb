# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :set_oauth_client, only: [:signin, :callback, :client_credentials, :user, :wares, :providers, :fetch_user_profile]
  before_action :set_access_token, only: [:fetch_user_profile]

  def signin
    redirect_to @client.auth_code.authorize_url(redirect_uri: redirect_uri), allow_other_host: true
  end

  def signout
    reset_session
    redirect_to root_path
  end

  def callback
    @oauth_data = @client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
    session[:access_token] = @oauth_data.token
  end

  def client_credentials
    access_token = @client.client_credentials.get_token
    session[:access_token] = access_token.token
    redirect_to root_path, notice: "Successfully authenticated with client credentials"
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
    response = @access_token.get('/api/v2/users/profile.json')  # Update the endpoint as per the documentation
    @user_profile = JSON.parse(response.body)['user']
    respond_to do |format|
      format.html { render 'show_user_profile' }
      format.json { render json: @user_profile }
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
