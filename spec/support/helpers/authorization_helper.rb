module Helpers
  module Authorization
    def authorization(user)
      "Bearer #{Api::V1::Tokens::AccessTokenGeneratorService.call(user:)}"
    end
  end
end
