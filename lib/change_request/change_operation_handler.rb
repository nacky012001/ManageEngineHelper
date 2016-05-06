module ManageEngineHelper
  class ChangeOperationHandler
    def handle(params)
      parse_params(params)
      results = []
      
      @result = "</br>============================================</br>"
      @result += call_operation(params)

      nil
    end

    def get_result
      @result
    end

private
    def parse_params(params)
      @operation = params[:action]
    end

    def call_operation(params)
      operation_requester = ChangeOperationRequester.new
      operation_requester = ChangeResponseDecorator.new(operation_requester)
      operation_requester.send(@operation, params)
    end
  end
end