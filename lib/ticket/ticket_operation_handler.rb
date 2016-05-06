module ManageEngineHelper
  class TicketOperationHandler
    def handle(params)
      parse_params(params)
      results = []
      
      @result = "</br>============================================</br>"
      @result += @ticket_ids.empty? ? "Ticket id is missing." : call_operation(params)

      nil
    end

    def get_result
      @result
    end

private
    def parse_params(params)
      @operation = params[:action]
      @ticket_ids = extract_ticket_ids(params[:ticket_ids])
    end

    def call_operation(params)
      @ticket_ids.collect do |ticket_id|
         operation_requester = TicketOperationRequester.new(ticket_id)
         operation_requester = TicketResponseDecorator.new(operation_requester)
         operation_requester.send(@operation, params)
      end.join("</br>============================================</br>")
    end

    def extract_ticket_ids(raw_ticket_ids)
      raw_ticket_ids.split(',')
                    .select { |s| is_integer?(s) }
                    .collect { |s| s.strip }
                    .uniq
    end

    def is_integer?(obj)
      obj.strip == obj.to_i.to_s
    end
  end
end