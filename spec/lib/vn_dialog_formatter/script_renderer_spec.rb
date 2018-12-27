require 'spec_helper'

require 'vn_dialog_formatter/script_model'
require 'vn_dialog_formatter/script_parser'
require 'vn_dialog_formatter/script_renderer'

include VnDialogFormatter


RSpec.describe Renderer do
  let(:basic_model) do
    reader = FileLineReader.new(File.expand_path('./correct.txt', __dir__))
    parser = ScriptParser.new(reader)
    parser.process
  end
  let(:model) do
    ScriptModelBuilder.new(basic_model).build
  end

  describe do
    it 'should render without error' do
      renderer = described_class.new({})
      expect { renderer.render_to_string(model) }.not_to raise_exception
    end
    it 'should generate string' do
      renderer = described_class.new({})
      res = renderer.render_to_string(model)
      puts res
    end
  end
end

