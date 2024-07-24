Rails.application.config.middleware.use OmniAuth::Builder do
  provider :oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
    site: ENV['OAUTH_BASE_URL'],
    authorize_url: ENV['OAUTH_BASE_URL'] + ENV['AUTHORIZATION_URL'],
    token_url: ENV['OAUTH_BASE_URL'] + ENV['TOKEN_URL'],
    redirect_uri: ENV['CALLBACK_URL']
  }
end
