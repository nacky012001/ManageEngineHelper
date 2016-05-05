require 'sinatra'
require 'httparty'
require 'json'
require './config/config.rb'
require './lib/operation_requester.rb'
require './lib/response_decorator.rb'
 
get '/' do
  erb :index
end

post '/do_action' do
  parse_params
  results = []
  
  @result = "</br>============================================</br>"
  @result += @ticket_ids.empty? ? "Ticket id is missing." : call_opertaion

  erb :index
end

def parse_params
  @operation = params[:action]
  @raw_ticket_ids = params[:ticket_ids]
  @ticket_ids = extract_ticket_ids(@raw_ticket_ids)
  @resolution = params[:resolution]
end

def call_opertaion
  @ticket_ids.collect do |ticket_id|
     operation_requester = ManageEngineHelper::OperationRequester.new(ticket_id)
     operation_requester = ManageEngineHelper::ResponseDecorator.new(operation_requester)
     operation_requester.send(@operation, params)
  end.join("</br>============================================</br>")
end

def extract_ticket_ids(raw_ticket_ids)
  ticket_ids = []

  @raw_ticket_ids.split(',').each do |s|
    ticket_ids << s.strip if is_integer?(s)
  end

  ticket_ids.uniq
end

def is_integer?(obj)
  obj.strip == obj.to_i.to_s
end
