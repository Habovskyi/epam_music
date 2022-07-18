module Api
  module Schemas
    class ApplicationSchema
      Dry::Schema.load_extensions(:json_schema)
    end
  end
end
