module ManageEngineHelper
  class OperationRequester
    attr_reader :ticket_id

    @@operations = {'GET_REQUEST' => [:post, 'request'],
                    'PICKUP_REQUEST' => [:post, 'request'],
                    'ADD_NOTE' => [:post, 'request', 'notes'],
                    'ADD_RESOLUTION' => [:post, 'request', 'resolution'],
                    'EDIT_REQUEST' => [:post, 'request']}

    def initialize(ticket_id)
      @ticket_id = ticket_id
    end

    def view_ticket(opts)
      get_request
    end

    def pick_up_with_first_response(opts)
      res = pick_up_request

      return res if is_failed?(res)

      # first response
      input_data = 
      "<Operation>
        <Details>
          <Notes>
            <Note>
              <parameter>
                <name>markFirstResponse</name>
                <value>true</value>
              </parameter>
              <parameter>
                <name>notesText</name>
                <value>Noted.</value>
              </parameter>
            </Note>
          </Notes>
         </Details>
       </Operation>"

      res = add_note(input_data)

      return res if is_failed?(res)

      get_request
    end

    def resolve_and_provide_resolution(opts)
     # add resolve message
     input_data = 
      "<Details>
        <resolution>
          <resolutiontext>#{opts[:resolution]}</resolutiontext>
        </resolution>
      </Details>"
			
     res = add_resolution(input_data)
                                  
     return res if is_failed?(res)
      
     # resolve ticket
     input_data = 
      "<Details>
        <parameter>
           <name>status</name>
           <value>Resolved</value>
        </parameter>
      </Details>"
      
      res = edit_request(input_data)

      return res if is_failed?(res)

      get_request
    end

private
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

    def is_failed?(res)
      res = res["API"] unless res["API"].nil?
      res = res["response"] unless res["response"].nil?
      res['operation']['result']['status'] != 'Success'
    end
  end
end