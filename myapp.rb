require 'sinatra'
require 'httparty'
require 'json'
require 'date'
require 'cgi'
require './config/config.rb'
require './lib/operation_requester.rb'
require './lib/ticket/ticket_operation_handler.rb'
require './lib/ticket/ticket_operation_requester.rb'
require './lib/ticket/ticket_response_decorator.rb'
require './lib/change_request/change_operation_handler.rb'
require './lib/change_request/change_operation_requester.rb'
require './lib/change_request/change_response_decorator.rb'
 
get '/' do
  @body = :ticket
  erb :index
end

post '/do_action' do
  @body = :ticket

  handler = ManageEngineHelper::TicketOperationHandler.new
  handler.handle(params)
  @result = handler.get_result  

  erb :index
end

get '/cr' do
  @body = :change_request
  @idcs = ['PH', 'TW', {'MO-Online'=>['production']}, 'MO-Landbase']
  erb :index
end

post '/cr/do_action' do
  @body = :change_request
  @idcs = ['PH', 'TW', {'MO-Online'=>['production']}, 'MO-Landbase']

  handler = ManageEngineHelper::ChangeOperationHandler.new
  handler.handle(params)
  @result = handler.get_result  
  
  erb :index
end