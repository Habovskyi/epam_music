RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    result = schema.call(**JSON.parse(response))
    result.success?
  end
end
