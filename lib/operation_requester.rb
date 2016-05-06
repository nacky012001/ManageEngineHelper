module ManageEngineHelper
  class OperationRequester
protected
    @@operations = {'GET_REQUEST' => [:post, 'request'],
                    'PICKUP_REQUEST' => [:post, 'request'],
                    'ADD_NOTE' => [:post, 'request', 'notes'],
                    'ADD_RESOLUTION' => [:post, 'request', 'resolution'],
                    'EDIT_REQUEST' => [:post, 'request'],
                    'ADD_REQUEST' => [:post, 'request']}

    def get_request
      operation = 'GET_REQUEST'
      method = @@operations['GET_REQUEST'][0]
      api = @@operations['GET_REQUEST'][1]

      res = HTTParty.send(:post, File.join($manage_engine_path, api, @ticket_id), :verify => false, 
                          :body=>{'OPERATION_NAME' => operation, 'TECHNICIAN_KEY' => $api_key}).parsed_response
                      
      res
    end

    def pick_up_request
      operation = 'PICKUP_REQUEST'
      method = @@operations['PICKUP_REQUEST'][0]
      api = @@operations['PICKUP_REQUEST'][1]

      res = HTTParty.send(:post, File.join($manage_engine_path, api, @ticket_id), :verify => false, 
                          :body=>{'OPERATION_NAME' => operation, 'TECHNICIAN_KEY' => $api_key}).parsed_response

      res
    end

    def add_note(input_data)
      operation = 'ADD_NOTE'
      method = @@operations['ADD_NOTE'][0]
      api = @@operations['ADD_NOTE'][1]
      sub_api = @@operations['ADD_NOTE'][2]
      res = HTTParty.send(:post, File.join($manage_engine_path, api, @ticket_id, sub_api), :verify => false, 
                          :body=>{'OPERATION_NAME' => operation, 'TECHNICIAN_KEY' => $api_key,
                                  'INPUT_DATA' => input_data}).parsed_response
      res
    end

    def add_resolution(input_data)
      operation = 'ADD_RESOLUTION'
      method = @@operations['ADD_RESOLUTION'][0]
      api = @@operations['ADD_RESOLUTION'][1]
      sub_api = @@operations['ADD_RESOLUTION'][2]

      res = HTTParty.send(:post, File.join($manage_engine_path, api, @ticket_id, sub_api), :verify => false, 
                          :body=>{'OPERATION_NAME' => operation, 'TECHNICIAN_KEY' => $api_key,
                                  'INPUT_DATA' => input_data}).parsed_response
      res
    end

    def edit_request(input_data)
      operation = 'EDIT_REQUEST'
      method = @@operations['EDIT_REQUEST'][0]
      api = @@operations['EDIT_REQUEST'][1]

      res = HTTParty.send(:post, File.join($manage_engine_path, api, @ticket_id), :verify => false, 
                          :body=>{'OPERATION_NAME' => operation, 'TECHNICIAN_KEY' => $api_key,
                                  'INPUT_DATA' => input_data}).parsed_response
      res
    end

    def add_request(input_data)
      operation = 'ADD_REQUEST'
      method = @@operations['ADD_REQUEST'][0]
      api = @@operations['ADD_REQUEST'][1]

      res = HTTParty.send(:post, File.join($manage_engine_path, api), :verify => false, 
                          :body=>{'OPERATION_NAME' => operation, 'TECHNICIAN_KEY' => $api_key,
                                  'INPUT_DATA' => input_data}).parsed_response
      res
    end

    def is_failed?(res)
      res = res["API"] unless res["API"].nil?
      res = res["response"] unless res["response"].nil?
      res['operation']['result']['status'] != 'Success'
    end
  end
end