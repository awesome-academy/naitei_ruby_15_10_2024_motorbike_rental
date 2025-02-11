class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  EXPIRATION_TIME = Rails.application.config_for(:settings).dig(:jwt, :expiration_time)
  def self.encode(payload, exp = EXPIRATION_TIME)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new body
  rescue StandardError
    nil
  end
end
