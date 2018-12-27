require_relative './script_model'

module VnDialogFormatter
  class ScriptParserError < StandardError;
  end
  class ScriptParser
    include BasicScriptModel

    attr_accessor :line_reader
    attr_reader :parser

    def initialize(reader)
      @line_reader = reader
      @current_base = ScriptNode.new(SCRIPT_BODY)
    end

    def process
      line = next_token
      @current_lineno = 0
      until line.nil?
        @current_lineno += 1
        step line
        line = next_token
      end
      unless @current_base.is_node_of_type?(SCRIPT_BODY)
        raise ScriptParserError, "Unclosed block detected: #{print_block(@current_base)}"
      end
      script_body
    end

    def script_body
      @current_base
    end


    private

    def step(line)
      if line.strip.empty?
        add(create_node(DELIMETER))
        return
      end
      if /^<>/ =~ line
        if current_base.is_node_of_type?(DIRECT_COPY)
          end_block
        else
          start_block(create_node(DIRECT_COPY))
        end
        return
      end
      if current_base.is_node_of_type?(DIRECT_COPY)
        current_base << TextNode.new(line, @current_lineno)
        return
      end
      if /^--\s*\(/ =~ line
        start_block(create_node(BRANCH, line))
        return
      end
      if /^--\s*$/ =~ line
        end_block
        return
      end
      if /^--\s*[^\(]+/u =~ line
        add create_node(EVENT, line)
        return
      end
      if /^\[.+\]/ =~ line
        add create_node(LOCATION_CHANGE, line)
        return
      end
      if /^!(.+)!$/ =~ line
        add create_node(ATTACHMENT_IMAGE, line)
        return
      end
      if /^<.+>$/ =~ line
        add create_node(NON_DIALOG_SERIF, line)
        return
      end
      if /^[^:]+(?<!\\):.+$/ =~ line
        add create_node(DIALOG_SERIF, line)
        return
      end
      if last_sibling && last_sibling.is_node_of_type?(NON_DIALOG_SERIF)
        last_sibling << TextNode.new(line, @current_lineno)
      else
        add create_node(NON_DIALOG_SERIF, line)
      end
      # register_error "Line of unknown type", line, @current_lineno
    end

    def create_node(type, content = nil)
      block = ScriptNode.new(type)
      block << TextNode.new(content, @current_lineno) unless content.nil?
      block.lineno = @current_lineno
      block
    end

    def start_block(block)
      unless block.kind_of? ScriptNode
        raise ArgumentError, 'block is not ScriptNode'
      end
      add(block)
      @current_base = block
    end

    def end_block
      @current_base = @current_base.parent
    end

    def current_base
      @current_base
    end

    def add(node)
      if node.kind_of? String
        current_base << TextNode.new(node, @current_lineno)
      else
        current_base << node
      end
    end

    def last_sibling
      current_base.children.last
    end

    def next_token
      @line_reader.next_line
    end

    def register_error(msg, line, lineno)
      printf "%d: %s -- \"%s\"", lineno, msg, line
    end

    def print_block(block)
      "#{block.type}(#{block.lineno}) - '#{block.children.last}'"
    end

  end


  class FileLineReader
    def initialize(filename)
      File.open filename do |f|
        @lines = f.readlines
      end
      @cursor = 0
    end

    def next_line
      return nil if @cursor >= @lines.length
      line = @lines[@cursor]
      @cursor += 1
      line.delete_suffix("\n")
    end
  end

  def extract(regex, str)
    m = regex.match str
    if m.nil?
      return nil
    end
    m[1]
  end

  class FormattedLineParser
    attr_reader :model, :root

    def initialize(line)
      @line = line
    end


    def parse
      @root = ParserNode.new(NODE_ROOT).with_content(@line)
      build_subtree @root
    end

    private

    def build_subtree(root)
      look_for_tag_by_regex(root, /(?:^|[^\\])\((?<T>.+?[^\\])\)/, "minds")
      look_for_tag_by_regex(root, /(?:^|[^\\])\*(?<T>.+?[^\\])\*/, "emotions")
      look_for_tag_by_regex(root, /(?:^|[^\\])_(?<T>\S.*?[^\s\\])_/, "emphasis")
      remove_mid_nodes root
      remove_empty_text_nodes root
      remove_mid_nodes_contents root
      remove_escape_symbols root, %w{_ * ( )}
      root
    end

    def look_for_tag_by_regex(root, regex, label)
      if root.leaf?
        line = root.content
        m = line.match(regex, 0)
        return root if m.nil?
        if regex.named_captures.has_key?('T')
          index = regex.named_captures.fetch('T')[0]
        else
          index = m.length > 1 ? 1 : 0
        end
        content = m[index]
        root << ParserNode.new(NODE_UNPARSED).with_content(line[0..m.begin(0)])
        root << ParserNode.new(NODE_WRAP, label).with_content(content)
        root << look_for_tag_by_regex(ParserNode.new(NODE_UNPARSED).with_content(line[m.end(0)..-1]), regex, label)
      else
        root.children.each do |child|
          look_for_tag_by_regex(child, regex, label)
        end
      end
      root
    end

    def remove_mid_nodes(root)
      if root.is_node_of_type?(NODE_UNPARSED)
        if root.leaf?
          root.mutate(NODE_PLAIN_TEXT, "plain")
        else
          root.children.each do |c|
            remove_mid_nodes c
          end
          root.parent.remove_mid_node(root)
        end
      else
        root.children.each do |c|
          remove_mid_nodes c
        end
      end
      root
    end

    def remove_empty_text_nodes(root)
      if root.is_node_of_type?(NODE_PLAIN_TEXT)
        if root.content.empty?
          root.parent.remove(root)
        end
      end
      root.children.each {|c| remove_empty_text_nodes c}
      root
    end

    def remove_mid_nodes_contents(root)
      root.traverse do |node|
        unless node.leaf?
          node.content = nil
        end
      end
    end

    def remove_escape_symbols(root, escaped_symbols = [])
      return if escaped_symbols.empty?
      root.traverse do |node|
        content = node.content
        if content
          escaped_symbols.each do |sym|
            content = content.gsub("\\" + sym, sym)
          end
          node.content = content
        end
      end
    end

  end

  NODE_ROOT = "ROOT"
  NODE_UNPARSED = "NODE_UNPARSED"
  NODE_WRAP = "NODE_WRAP"
  # NODE_FORMATTED_TEXT = "NODE_FORMATTED_TEXT"
  NODE_PLAIN_TEXT = "NODE_PLAIN_TEXT"
  class ParserNode < TreeModel::Node
    attr_reader :label
    attr_accessor :content

    def initialize(type, label = nil)
      super(type)
      @label = label
    end

    def with_content(content)
      @content = content
      self
    end

    def mutate(new_type, label = self.label)
      @type = new_type
      @label = label
    end

    def remove_mid_node(node)
      index = children.index(node)
      children.insert(index, *node.children)
      node.children.each {|c| c.parent = self}
      self.remove(node)
    end

    def name
      label || type
    end

    def remove(node)
      children.delete(node)
    end

    def leaf?
      children.empty?
    end

    def traverse(&block)
      traverse_internal(self, &block)
    end

    def node_to_s
      "[#{self.name}]--[#{self.content}]"
    end

    def join_contents
      collect_contents.join('')
    end

    def collect_contents(to = [])
      self.traverse do |node|
        to << node.content if node.content
      end
      to
    end

    def to_s
      self.join_contents
    end

    private

    def traverse_internal(root, &block)
      yield root
      root.children.each {|c| traverse_internal(c, &block)}
    end
  end

  class ScriptModelBuilder
    def initialize(script_elements_tree)
      @source_tree = script_elements_tree
      @parser = ElementsParserImpl.new
    end

    def build
      @result_tree = ParsedScriptModel::Script.new

      parallel_traverse @source_tree.children, @result_tree

      @result_tree
    end

    private

    def parallel_traverse(list, result_root)
      p = @parser
      [list].flatten.each do |src_node|
        case src_node.type
        when BasicScriptModel::EVENT
          result_root << p.create_event(src_node)
        when
        BasicScriptModel::DELIMETER,
          BasicScriptModel::ATTACHMENT_IMAGE,
          BasicScriptModel::DIRECT_COPY
          result_root << p.create_attachment(src_node)
        when BasicScriptModel::LOCATION_CHANGE
          result_root << p.create_note(src_node)
        when BasicScriptModel::DIALOG_SERIF
          result_root << p.create_serif(src_node)
        when BasicScriptModel::NON_DIALOG_SERIF
          result_root << p.create_non_dialog_serif(src_node)
        when BasicScriptModel::BRANCH
          branch = p.create_branch(src_node)
          parallel_traverse src_node.rest_children, branch
          result_root << branch
          # parallel_traverse src_node, branch
        else
          puts "Unknown type of script node: #{src_node.type}"
        end
      end
    end
  end
  class ElementsParserImpl
    include ParsedScriptModel

    def create_branch(node)
      ParsedScriptModel::Branch
        .with_name(plain(extract(/\((.*)\)/, node.value).strip))
        .with_lineno(node.lineno)
    end

    def create_event(node)
      ParsedScriptModel::Event
        .with_content(format(extract(/^--(.+)/, node.value).strip))
        .with_lineno(node.lineno)
    end

    def create_note(node)
      Note
        .with_content(plain(extract(/^\[(.+)\]/, node.value).strip))
        .with_lineno(node.lineno)
    end

    def create_attachment(attachment_node)
      if attachment_node.is_node_of_type?(BasicScriptModel::DIRECT_COPY)
        a = ParsedScriptModel::Attachment.of_type(ParsedScriptModel::ATTACHMENT_FREE_TEXT)
        attachment_node.children.each do |c|
          a << plain(c.value)
        end
        return a.with_lineno(attachment_node.lineno)
      end
      if attachment_node.is_node_of_type?(BasicScriptModel::DELIMETER)
        return ParsedScriptModel::Attachment
                 .of_type(ParsedScriptModel::ATTACHMENT_DELIMETER)
                 .with_lineno(attachment_node.lineno)
      end
      line = attachment_node.children.first.value
      ParsedScriptModel::Attachment
        .of_type(ParsedScriptModel::ATTACHMENT_IMAGE)
        .with_value(extract(/!(.+)!/, line).strip)
        .with_lineno(attachment_node.lineno)
    end

    def create_non_dialog_serif(node)
      head = node.first_child
      res = ParsedScriptModel::Serif.new(ParsedScriptModel::SERIF_NON_DIALOG)
      res.lineno = node.lineno
      if /^<(.+)>$/ =~ head.value
        res.name = $~[1]
      else
        res << format(head.value)
      end
      node.rest_children.each do |c|
        res << format(c.value)
      end
      res
    end

    def create_serif(node)
      str = node.first_child.value
      m = /^([^:]+):(.+)$/.match str
      if m.nil?
        name = nil
        content = format str
      else
        name = m[1]
        content = format m[2].lstrip
      end
      block = ParsedScriptModel::Serif.new(ParsedScriptModel::SERIF_DIALOG)
      block.lineno = node.lineno
      block.name = name
      block << content
      block
    end

    private

    def format(plain_text)
      ParsedScriptModel::ParsedText.new FormattedLineParser.new(plain_text).parse
    end

    def plain(plain_text)
      ParsedScriptModel::PlainText.new(plain_text)
    end
  end
end