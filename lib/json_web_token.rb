# lib for JWT
class JsonWebToken
  ENCODE_ALGORITHM = 'HS256'.freeze
  SECRET_KEY = Rails.application.credentials.jwt_secret

  class << self
    def encode(payload, exp = 30.minutes.from_now)
      payload[:exp] = exp.to_f
      JWT.encode(payload, SECRET_KEY, ENCODE_ALGORITHM)
    end

    def decode(token)
      JWT.decode(token, SECRET_KEY, algorithm: ENCODE_ALGORITHM)
    end

    def payload(token)
      HashWithIndifferentAccess.new(decode(token)[0])
    end
  end
end
