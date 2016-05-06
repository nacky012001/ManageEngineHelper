module ManageEngineHelper
  class ChangeOperationRequester < OperationRequester
    @@generic_information_columns = 
      [:request_template, :requester, :change_area, :downtime, :approved_by, :frontend, :duration, :description]

    def create_change(opts)
      @params = opts
       
      requests = parse_params

      requests.collect do |request|
        input_data = 
        "<Operation>
          <Details>
            #{parameter_template('requesttemplate', request[:request_template])}
            #{parameter_template('requester', request[:requester])}
            #{parameter_template('change area', request[:change_area])}
            #{parameter_template('downtime', request[:downtime])}
            #{parameter_template('approved by', request[:approved_by])}
            #{parameter_template('subject', request[:subject])}
            #{parameter_template('frontend', request[:frontend])}
            #{parameter_template('estimate duration (mins)', request[:duration])}
            #{parameter_template('description', request[:description])}
            #{parameter_template('data center', request[:data_center])}
            #{parameter_template('target date', request[:target_date])}
            #{parameter_template('environment', request[:environment])}
            #{parameter_template('property id', request[:property_id])}
          </Details>
        </Operation>"
        
        res = add_request(input_data)

        return res if is_failed?(res)

        @ticket_id = res["API"]["response"]["operation"]["Details"].first["workorderid"]

        get_request
      end
    end

private
    def parse_params
      # compose generic columns
      generic_information = {}
      @@generic_information_columns.each do |col|
        generic_information[col] = send(col)
      end
      
      # get the idc and env
      requests = 
        @params.select { |k, v| k.include?('date') && is_date?(v) }
               .map { |k, v| k.split('_')[0..1] } # ph_production_date => [ph, production]

      # compose request
      requests.collect do |idc, env|
        { 
          subject: subject(idc, env),
          data_center: "#{idc.upcase}IDC",
          environment: env.capitalize,
          property_id: properties(idc),
          target_date: target_date(idc, env)
        }.merge(generic_information)
      end
    end

    def request_template
      "Change Request (CR)"
    end

    def requester
      @params[:requester]
    end

    def change_area
      @params[:change_area]
    end

    def downtime
      @params[:downtime]
    end

    def approved_by
      @params[:approved_by]
    end

    def subject(idc, env)
      "#{@params[:subject]} (#{idc.upcase}IDC #{env.capitalize})"
    end

    def frontend
      @params[:frontend]
    end

    def duration
      @params[:duration]
    end

    def description
      CGI.escapeHTML(
        "</p><strong>Instruction</strong></br>
         1. Fill in all required (*) fields above.</br>
         2. Fill in the following information.</br>
         3. Save the request.</br>
         4. Attach the TR details 4 days before deployment.
         <hr>
         <strong>Change Description</strong></br>
         #{@params[:subject]}</br>
         <hr>
         <strong>Rollback Plan</strong></br>
         #{@params[:rollback]}</br>
         <hr>
         <strong>Impacted</strong> (E.g. Report system not available; Stop App/Core service)
         #{@params[:impacted]}</br>
         <hr>
         <strong>Testing</strong>
         #{@params[:testing]}</br>
         <hr>")
    end

    def properties(idc)
      @params["#{idc}_properties"]
    end

    def target_date(idc, env)
      date = @params["#{idc}_#{env}_date"]
      DateTime.parse(date)
              .strftime('%d %b %Y, %H:%M:%S')
    end

    def is_date?(val)
      !val.empty? && /^\d\d\d\d-\d\d-\d\d \d\d:\d\d$/ === val
    end

    def parameter_template(name, value)
      "<parameter>
         <name>#{name}</name>
         <value>#{value}</value>
       </parameter>"
    end
  end
end