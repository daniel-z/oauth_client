class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]

  def new
    # Página inicial para ingresar detalles del cliente OAuth
  end

  def create
    # Iniciar el flujo OAuth
    redirect_to user_rx_omniauth_authorize_path
  end

  def callback
    # Captura la respuesta de OAuth y muestra los tokens
    @data = request.env['omniauth.auth']
  end
end
