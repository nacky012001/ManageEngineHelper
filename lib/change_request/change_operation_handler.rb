module ManageEngineHelper
  class ChangeOperationHandler
    def handle(params)
      parse_params(params)
      results = []
      
      @result = "</br>============================================</br>"
      @result += call_operation(params) if (check_params(params))
      
      nil
    end

    def get_result
      @result
    end

private
    def parse_params(params)
      @operation = params[:action]
    end

    def check_params(params)
      require_params = [:subject, :requester, :duration, :executed_by]
      missing_params = 
        require_params.select { |p| params[p].nil? || params[p].empty? }

      @result += "Missing " + missing_params.map { |p| p.capitalize }.join(', ')

      missing_params.empty?
    end

    def call_operation(params)
      operation_requester = ChangeOperationRequester.new
      operation_requester = ChangeResponseDecorator.new(operation_requester)
      operation_requester.send(@operation, params)
    end
  end
end