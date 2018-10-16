module Operations
  class AddPost
    attr_reader :attributes, :post
    attr_accessor :user_id

    def initialize(attributes = {})
      @attributes = attributes
      @user_id = attributes[:user_id]
    end

    def call
      @post = Post.new(attributes.slice(:title, :excerpt, :slug, :published_at, :source_filter))
      @post.owner_id = user_id ? user_id : User.admin_id
      @post.contents.build(attributes.slice(:content).merge(:type => 'source'))
      @post.contents.build(:content => translate_source, :type => 'filtered')
      @post.save
      self
    end

    def result
      Result.new(@post)
    end

    private

    def translate_source
      # TODO
      attributes[:content]
    end

    class Result
      attr_accessor :post
      def initialize(object)
        @post = object
      end

      def ok?
        post.valid?
      end

      def error?
        !post.valid?
      end
    end
  end

end