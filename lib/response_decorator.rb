module ManageEngineHelper
  class ResponseDecorator
    def initialize(operation_requester)
      @operation_requester = operation_requester
    end

    def view_ticket(opts)
      decorate(__method__, opts)
    end

    def pick_up_with_first_response(opts)
      decorate(__method__, opts)
    end

    def resolve_and_provide_resolution(opts)
      decorate(__method__, opts)
    end

private
    def decorate(method, opts)
      res = get_response(method, opts)
      message = parse_response(res, method)
      message
    end

    def get_response(method, opts)
      @operation_requester.send(method, opts)
    end

    def parse_response(res, method)
      message = ""

      res = res["API"] unless res["API"].nil?
      res = res["response"] unless res["response"].nil?

      if res['operation']['result']['status'] != 'Success'
        message += compose_failed_message(res)
      else
        message += send("compose_#{method}_message", res)
      end

      message
    end

    def compose_failed_message(res)
      message = ""
      status = res['operation']['result']['status']
      error_message = res['operation']['result']['message']
      operation_name = res['operation']['name']

      message += "Ticket: ##{@operation_requester.ticket_id}</br>" 
      message += "Status: '#{status}</br>"
      message += "Error message: '#{error_message}'</br>"

      message
    end

    def compose_success_message(res, method)
      message = ""

      details = res['operation']['Details']['parameter']
      ticket_status = details.select { |parameter| parameter['name'] == 'status' }.first
			ticket_status = ticket_status ? ticket_status['value'] : 'None'
      technician = details.select { |parameter| parameter['name'] == 'technician' }.first
			technician = technician ? technician['value'] : 'None'
      description = details.select { |parameter| parameter['name'] == 'description' }.first
			description = description ? description['value'] : 'None'	
			
      message += "Ticket: ##{@operation_requester.ticket_id}</br>"
      message += "Request: #{method}</br>"
      message += "Technician: #{technician}</br>"
      message += "Ticket Status: #{ticket_status}</br>"
      message += "Description: </br>#{description}"

      message
    end

    def compose_view_ticket_message(res)
      compose_success_message(res, 'View ticket')
    end

    def compose_pick_up_with_first_response_message(res)
      compose_success_message(res, 'Pick up with first response')
    end

    def compose_resolve_and_provide_resolution_message(res)
      compose_success_message(res, 'Resolve and provide resolution')
    end
  end
end