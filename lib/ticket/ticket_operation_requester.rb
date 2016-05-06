module ManageEngineHelper
  class TicketOperationRequester < OperationRequester
    attr_reader :ticket_id

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
  end
end