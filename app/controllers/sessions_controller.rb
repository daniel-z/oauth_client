# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :set_oauth_client, only: [:signin, :callback, :user, :fetch_user_profile, :fetch_organizations_data, :fetch_action_items]
  before_action :set_access_token, only: [:fetch_user_profile, :fetch_organizations_data, :fetch_action_items]

  def signin
    redirect_to @client.auth_code.authorize_url(redirect_uri: redirect_uri), allow_other_host: true
  end

  def signout
    session[:token_info] = nil
    reset_session
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

  def token
    render plain: session[:access_token]
  end

  def fetch_user_profile
    if session[:token_info].nil?
      redirect_to root_path, alert: "You need to authenticate first"
      return
    end

    response = @access_token.get('/api/v2/users/profile.json')
    @user_profile_data = JSON.parse(response.body)['user']
    respond_to do |format|
      format.html { render 'show_user_profile' }
      format.json { render json: @user_profile_data }
    end
  end

  def fetch_organizations_data
    if session[:token_info].nil?
      redirect_to root_path, alert: "You need to authenticate first"
      return
    end

    response = @access_token.get('/api/v2/organizations.json')
    @organizations_data = JSON.parse(response.body)
    respond_to do |format|
      format.html { render 'show_organizations_data' }
      format.json { render json: @organizations_data }
    end
  end

  def fetch_action_items
    if session[:token_info].nil?
      redirect_to root_path, alert: "You need to authenticate first"
      return
    end

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
    if session[:access_token].present?
      @access_token = OAuth2::AccessToken.new(@client, session[:access_token])
    else
      @access_token = nil
    end
  end

  def redirect_uri
    ENV['CALLBACK_URL']
  end
end
