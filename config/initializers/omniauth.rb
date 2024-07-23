Rails.application.config.middleware.use OmniAuth::Builder do
  provider :oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
    client_options: {
      site: 'http://app.test:3030',  # Ajusta esta URL al dominio de tu servidor `rx`
      authorize_url: '/oauth/authorize',
      token_url: '/oauth/token'
    }
  }
end
