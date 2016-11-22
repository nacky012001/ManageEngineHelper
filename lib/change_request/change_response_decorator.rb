module ManageEngineHelper
  class ChangeResponseDecorator
    def initialize(operation_requester)
      @operation_requester = operation_requester
    end

    def create_change(opts)
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

      res.each do |r|
        r = r["API"] unless r["API"].nil?
        r = r["response"] unless r["response"].nil?

        if r['operation']['result']['status'] != 'Success'
          message += compose_failed_message(r)
        else
          message += send("compose_#{method}_message", r)
        end

        message += "======================================================"
      end

      message
    end

    def compose_failed_message(res)
      message = ""
      status = res['operation']['result']['status']
      error_message = res['operation']['result']['message']
      operation_name = res['operation']['name']

      message += "Status: '#{status}</br>"
      message += "Error message: '#{error_message}'</br>"

      message
    end

    def compose_success_message(res, method)
      message = ""

      details = res['operation']['Details']['parameter']
      request_id = details.select { |parameter| parameter['name'] == 'workorderid' }.first['value']
      subject = details.select { |parameter| parameter['name'] == 'subject' }.first['value']
      requester = details.select { |parameter| parameter['name'] == 'requester' }.first['value']
      data_center = details.select { |parameter| parameter['name'] == 'data center' }.first['value']
      target_date = details.select { |parameter| parameter['name'] == 'target date' }.first['value']
      environment = details.select { |parameter| parameter['name'] == 'environment' }.first['value']
      duration = details.select { |parameter| parameter['name'] == 'estimate duration (mins)' }.first['value']
      executed_by = details.select { |parameter| parameter['name'] == 'executed by' }.first['value']
      change_area = details.select { |parameter| parameter['name'] == 'change area' }.first['value']
      frontend = details.select { |parameter| parameter['name'] == 'frontend' }.first['value']
      downtime = details.select { |parameter| parameter['name'] == 'downtime' }.first['value']
      description = details.select { |parameter| parameter['name'] == 'description' }.first['value']
      
      message += "Change: ##{request_id}</br>"
      message += "Subject: #{subject}</br>"
      message += "Requester: #{requester}</br>"
      message += "Data center: #{data_center}</br>"
      message += "Target date: #{target_date}</br>"
      message += "Environment: #{environment}</br>"
      message += "Estimate duration (mins): #{duration}</br>"
      message += "Executed by: #{executed_by}</br>"
      message += "Change area: #{change_area}</br>"
      message += "Front-end: #{frontend}</br>"
      message += "Downtime: #{downtime}</br>"
      message += "Description: </br>"
      message += "<div style='padding-left:30px'>#{description}</div></br>"

      message
    end

    def compose_create_change_message(res)
      compose_success_message(res, 'View ticket')
    end
  end
end