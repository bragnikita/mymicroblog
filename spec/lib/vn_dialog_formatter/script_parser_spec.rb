require 'spec_helper'

require 'vn_dialog_formatter/script_model'
require 'vn_dialog_formatter/script_parser'

include VnDialogFormatter::BasicScriptModel
include VnDialogFormatter

RSpec.describe VnDialogFormatter::ScriptParser do

  describe "correct script" do
    let(:reader) do
      VnDialogFormatter::FileLineReader.new(File.expand_path('./correct.txt', __dir__))
    end
    let(:parser) do
      VnDialogFormatter::ScriptParser.new(reader)
    end
    it 'throws no exceptions' do
      expect {parser.process}.not_to raise_error
    end
    it 'generates model' do
      parser.process
      script = parser.script_body
      expect(script).not_to be_nil
      expect(script.type).to eq(SCRIPT_BODY)
      expect(script.children).to have_exactly(12).items
      expect(script[7].children).to have_exactly(4).items

      expect(script[0]).to have_type(LOCATION_CHANGE)
      expect(script[1]).to have_type(DIALOG_SERIF)
      expect(script[2]).to have_type(DIALOG_SERIF)
      expect(script[3]).to have_type(NON_DIALOG_SERIF)
      expect(script[4]).to have_type(EVENT)
      expect(script[5]).to have_type(DIALOG_SERIF)
      expect(script[6]).to have_type(NON_DIALOG_SERIF)
      expect(script[7]).to have_type(BRANCH)
      expect(script[8]).to have_type(ATTACHMENT_IMAGE)
      expect(script[9]).to have_type(DELIMETER)
      expect(script[10]).to have_type(DIRECT_COPY)
      expect(script[11]).to have_type(EVENT)

      branch = script[7]

      expect(branch[0]).to have_type(TEXT_NODE)
      expect(branch[1]).to have_type(NON_DIALOG_SERIF)
      expect(branch[2]).to have_type(LOCATION_CHANGE)
      expect(branch[3]).to have_type(DIALOG_SERIF)
    end
  end
end

RSpec.describe VnDialogFormatter::FormattedLineParser do
  let(:root) {parser.parse}
  let(:parser) {described_class.new(line)}
  before do
    puts root.print
  end
  describe "without escaped symbols" do
    let(:line) {"al fefw snikta (sfdds fsfdf ) !! *fdsfd* speco (afdsfsd!)"}
    it 'should return root' do
      expect(root).to have_label("root")
      expect(root.children).to have(6).items
      expect(root.parent).to be_nil
      expect(root[0]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(root[1]).to have_label('minds').and have_type(NODE_WRAP)
      expect(root[2]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(root[3]).to have_label('emotions').and have_type(NODE_WRAP)
      expect(root[4]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(root[5]).to have_label('minds').and have_type(NODE_WRAP)

      expect(root.join_contents).to eq('al fefw snikta sfdds fsfdf  !! fdsfd speco afdsfsd!')
    end
  end
  describe "with escaped symbols" do
    let(:line) {'al fefw snikta \(sfdds fsfdf \) !! \*fdsfd\* speco (afdsfsd!)'}
    it 'should return root' do
      expect(root[0]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(root[1]).to have_label('minds').and have_type(NODE_WRAP)
      expect(root.join_contents).to eq('al fefw snikta (sfdds fsfdf ) !! *fdsfd* speco afdsfsd!')
    end
  end
  describe "with nested tags" do
    let(:line) {'al fefw snikta (sfdds *fdsfd* fsfdf ) !! speco (afdsfsd!)'}
    it 'should return root' do
      expect(root[0]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(root[1]).to have_label('minds').and have_type(NODE_WRAP)
      branch = root[1]
      expect(branch[0]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(branch[1]).to have_label('emotions').and have_type(NODE_WRAP)
      expect(branch[2]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(root[2]).to have_label('plain').and have_type(NODE_PLAIN_TEXT)
      expect(root[3]).to have_label('minds').and have_type(NODE_WRAP)

      expect(root.join_contents).to eq('al fefw snikta sfdds fdsfd fsfdf  !! speco afdsfsd!')
    end
  end

  describe "emphasis" do
    let(:line) {'al fefw snikta (sfdds fsfdf _деньги ничего не\_решают_ ) !! где-то_ '}
    it 'should return root' do
      expect(root.children).to have(3).items
      branch = root[1]
      expect(branch.children).to have(3).items
      expect(branch[1]).to have_label('emphasis').and have_type(NODE_WRAP)
      expect(root.join_contents).to eq('al fefw snikta sfdds fsfdf деньги ничего не_решают  !! где-то_ ')
    end
  end

  describe "when there are escaped symbols" do
    let(:line) {'afsf wfe _a \_sfdf  t_\*{fsdf}\* ( \(plainext\) )  \≠fs '}
    it 'replaces them with original symbols' do
      transformed_line = root.join_contents
      expect(transformed_line).to eq('afsf wfe a _sfdf  t*{fsdf}*  (plainext)   \\≠fs ')
    end
  end

end

RSpec.describe VnDialogFormatter::ScriptModelBuilder do
  let(:basic_model) do
    reader = VnDialogFormatter::FileLineReader.new(File.expand_path('./correct.txt', __dir__))
    parser = VnDialogFormatter::ScriptParser.new(reader)
    parser.process
  end
  describe 'when script tree is recognizable' do
    let(:model) do
      described_class.new(basic_model).build
    end

    it 'builds model' do
      expect {model}.to_not raise_exception
      puts model.print
    end
    it 'has correct top-level elements' do
      expect(model).to be_a(ParsedScriptModel::Script)
      expect(model.children).to all(be_kind_of(ParsedScriptModel::ScriptNode))
    end
    it 'has correct branched elements' do
      branch = model[7]
      expect(branch).to be_a(ParsedScriptModel::Branch)
      expect(branch.name).to have_text('воспоминания')
      expect(branch.children).to have(3).items
      expect(branch.children[0]).to be_a(ParsedScriptModel::Serif).and have_category(ParsedScriptModel::SERIF_NON_DIALOG)
      expect(branch.children[1]).to be_a(ParsedScriptModel::Note)
      expect(branch.children[2]).to be_a(ParsedScriptModel::Serif).and have_category(ParsedScriptModel::SERIF_DIALOG)
    end
    it 'has correct text elements' do
      expect(model[0].content).to be_a(ParsedScriptModel::PlainText).and have_text('гостиная')
      expect(model[1].first_child).to be_a(ParsedScriptModel::ParsedText).and have_text('Привет!')
      expect(model[3].first_child).to be_a(ParsedScriptModel::ParsedText).and have_text('Самое обычное начало дня')
      expect(model[4].content).to be_a(ParsedScriptModel::ParsedText).and have_text('грохот')
      expect(model[8].value).to be_a(String).and have_text('изображение.png')
      expect(model[10].first_child).to be_a(ParsedScriptModel::PlainText).and have_text('<h2> Глава 0 </h2>')
    end
  end
end

RSpec::Matchers.define :have_type do |type|
  match do |block|
    block.is_node_of_type?(type)
  end
end
RSpec::Matchers.define :have_label do |label|
  match do |block|
    block.label == label
  end
end
RSpec::Matchers.define :have_category do |cat|
  match do |block|
    block.category == cat
  end
end
RSpec::Matchers.define :have_text do |text|
  match do |node|
    if node.kind_of?(ParsedScriptModel::PlainText)
      return node.plain_text == text
    elsif node.kind_of?(ParsedScriptModel::ParsedText)
      return node.text_root.to_s == text
    else
      return node.to_s == text
    end
  end
end
