RSpec::Matchers.define :has_characters do
  match do |actual|
    actual && actual.instance_of?(String) && actual.strip.length > 0
  end
end

RSpec::Matchers.alias_matcher :has_symbols, :has_characters
RSpec::Matchers.alias_matcher :not_blank, :has_characters