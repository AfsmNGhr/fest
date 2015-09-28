require_relative '../spec_helper'

describe Fest do
  describe '#initialize' do
    params = YAML.load_file("#{GEM_ROOT}/config/default.yml")
    let(:loader) { described_class.new }

    params.each do |key, value|
      let(":#{key}") { value.is_a?(Array) ? eval(value.join('; ')) : value }

      context "when initialized with a set of @#{key}" do
        it "from params['#{key}']" do
          @path = params['path'] if key == 'index'
          expect(loader.instance_variable_get("@#{key}".to_sym)).
            to eq(value.is_a?(Array) ? eval(value.join('; ')) : value)
        end
      end
    end
  end
end
