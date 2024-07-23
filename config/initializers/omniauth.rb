Rails.application.config.middleware.use OmniAuth::Builder do
  provider :oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
    site: 'http://backoffice.test:3030',
    authorize_url: '/oauth/authorize',
    token_url: '/oauth/token',
    callback_path: '/auth/oauth/callback'
  }
end
