# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]

  def new
    # Display the starting form where users can trigger OAuth
  end

  def create
    # Redirect to OAuth provider's authorization URL with the proper callback URL
    redirect_to oauth_authorize_url(client_id: ENV['CLIENT_ID'], redirect_uri: callback_url), allow_other_host: true
  end

  def callback
    # Handle the callback from the OAuth provider
    @data = request.env['omniauth.auth']
    # Redirect to root with an alert if no data is received
    redirect_to root_path, alert: "OAuth Error: Data not received." and return unless @data
  end

  private

  def callback_url
    'http://localhost:3010/auth/oauth/callback'
  end

  def oauth_authorize_url(client_id:, redirect_uri:)
    "http://backoffice.test:3030/oauth/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{redirect_uri}"
  end
end
