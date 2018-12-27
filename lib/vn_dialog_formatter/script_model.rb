module VnDialogFormatter

  module HasLineNo
    attr_accessor :lineno

    def with_lineno(lineno)
      self.lineno = lineno
      self
    end
  end

  module TreeModel
    class Node
      include HasLineNo

      attr_reader :children, :type
      attr_accessor :parent


      def initialize(type = self.class.name)
        @children = []
        @type = type
      end

      def is_node_of_type?(type)
        self.type == type
      end

      def << (child)
        return if child.nil?
        self.children << child
        if child.kind_of? Node
          child.parent = self
        end
      end

      def [] (index)
        self.children[index]
      end

      def node_to_s
        "#{self.type}[#{self.lineno}]"
      end

      def first_child
        self.children.first
      end

      def rest_children
        self.children[1..-1]
      end

      def value
        child = children.first
        return nil if child.nil?
        if child.respond_to? 'value'
          child.value
        else
          child
        end
      end

      def print(lvl = 0)
        if self.children.empty?
          return lpad node_to_s, lvl
        end
        lines = []
        lines << lpad(node_to_s, lvl)
        self.children.each do |c|
          if c.kind_of?(Node)
            lines << c.print(lvl + 1)
          else
            lines << lpad(c.to_s, lvl + 1)
          end
        end
        # lines << lpad(node_to_s, lvl)
        lines.join("\n")
      end

      protected

      def lpad(str, lvl)
        s = ""
        lvl.times {s = s + "  "}
        s + str
      end

    end
  end
  module BasicScriptModel
    ATTACHMENT_IMAGE = "ATTACHMENT_IMAGE"
    LOCATION_CHANGE = "LOCATION_CHANGE"
    EVENT = "EVENT"
    BRANCH = "BRANCH"
    SCRIPT_BODY = "SCRIPT_BODY"
    DIALOG_SERIF = "DIALOG_SERIF"
    NON_DIALOG_SERIF = "NON_DIALOG_SERIF"
    DIRECT_COPY = "DIRECT_COPY"
    DELIMETER = "DELIMETER"
    TEXT_NODE = "TEXT_NODE"

    class ScriptNode < TreeModel::Node
      def first_child_text
        child = self.first_child
        if child kind_of? TextNode
          return child.value
        end
        nil
      end
    end

    class TextNode
      include HasLineNo
      attr_accessor :value

      def initialize(text, lineno)
        @value = text
        @lineno = lineno
      end

      def is_node_of_type?(type)
        type == BasicScriptModel::TEXT_NODE
      end

      def type
        BasicScriptModel::TEXT_NODE
      end

      def to_s
        "TEXT_NODE [#{self.lineno}]  (#{self.value})"
      end
    end

  end

  module ParsedScriptModel
    ATTACHMENT_FREE_TEXT = "ATTACHMENT_FREE_TEXT"
    ATTACHMENT_IMAGE = "ATTACHMENT_IMAGE"
    ATTACHMENT_DELIMETER = "ATTACHMENT_DELIMETER"
    SERIF_NON_DIALOG = "SERIF_NON_DIALOG"
    SERIF_DIALOG = "SERIF_DIALOG"

    class Script < TreeModel::Node
      def initialize
        super("Script")
      end
      # attr_reader :rendering_props
    end

    class ScriptNode < TreeModel::Node
      attr_accessor :category

      def initialize(category = nil)
        super(self.class.name.split("::").last)
        @category = category
      end

      def serif?
        self.kind_of?(Serif);
      end

      def branch?
        self.kind_of?(Branch)
      end

      def event?
        self.kind_of(Event)
      end

      def node?
        self.kind_of?(Note)
      end

      def attachment?
        self.kind_of?(Attachment)
      end

      def print(lvl = 0)
        if self.children.empty?
          return lpad print_node, lvl
        end
        lines = []
        lines << lpad(print_node, lvl)
        self.children.each do |c|
          if c.kind_of?(ScriptNode)
            lines << c.print(lvl + 1)
          else
            lines << lpad(c.to_s, lvl + 1)
          end
        end
        lines.join("\n")
      end

      def node_to_s
        ""
      end

      def to_s
        self.print_node
      end

      protected

      def print_node
        "[#{self.type}(#{category})]--#{self.node_to_s}"
      end
    end

    class Serif < ScriptNode
      attr_accessor :name

      def initialize(category)
        super
      end

      def node_to_s
        "#{name || "no name"}"
      end

      def to_s
        res = []
        children.each do |c|
          res << c.to_s
        end
        "#{name || "no name"}:#{res.join('\n')}"
      end

    end

    class Branch < ScriptNode
      attr_accessor :name

      def initialize
        super("default")
      end

      def self.with_name(name)
        e = Branch.new
        e.name = name
        e
      end

      def node_to_s
        "#{name}"
      end
    end

    class Event < ScriptNode
      attr_accessor :content

      def initialize
        super("default")
      end

      def self.with_content(content)
        e = Event.new
        e.content = content
        e
      end

      def node_to_s
        "#{content}"
      end
    end

    class Note < ScriptNode
      attr_accessor :content

      def initialize
        super("default")
      end

      def self.with_content(content)
        e = Note.new
        e.content = content
        e
      end

      def node_to_s
        "#{content}"
      end
    end

    class Attachment < ScriptNode
      attr_accessor :value

      def initialize(attachment_type, value = nil)
        super(attachment_type)
        self.value = value
      end

      def self.of_type(attachment_type)
        Attachment.new(attachment_type)
      end

      def with_value(val)
        self.value = val
        self
      end

      def node_to_s
        "#{value}"
      end
    end

    class ParsedText
      include HasLineNo
      attr_accessor :text_root

      def initialize(root)
        @text_root = root
      end

      def to_s
        "#{self.text_root.join_contents}"
      end
    end

    class PlainText
      include HasLineNo
      attr_accessor :plain_text

      def initialize(text = "")
        @plain_text = text
      end

      def to_s
        "#{self.plain_text}"
      end
    end
  end
end