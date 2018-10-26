module Operations
  class UpdatePost

    def from_params(parameters)
      @id = parameters[:id]
      @mass_update = parameters.slice(:title, :slug, :excerpt)
      @contents = parameters[:contents]
    end

    def call!
      @result = self.doWork
      unless @result
        @result = OperationResult.ok(@model)
      end
    end

    def call
      begin
        self.doWork
      rescue Exception => e
        @result = OperationResult.failed(e, @model)
      end
    end

    def doWork
      @model = Post.update(@id, @mass_update)
      unless @model.valid?
        raise "Could not update the post #{@model.id}"
      end
      if @contents
        if @contents.has_key? :main
          @model.source_content_obj.update!({content: @contents[:main]})
          @model.filtered_content_obj.update!({content: @contents[:main]})
        end
      end
    end


  end

  class OperationResult
    attr_accessor :model, :result, :message

    def self.failed(explain, model)
      message = explain
      if explain.kind_of?(Exception)
        message = explain.message
      end
      OperationResult.new(false, model: model, message: message)
    end

    def self.ok(model)
      OperationResult.new(true, model: model)
    end


    def initialize(result = true, **args)
      @result = result
      @model = args[:model]
      @message = args[:message]
    end

    def ok?
      @result
    end

    def failed?
      !self.ok?
    end

    def error
      {
        message: @message
      }
    end
  end
end