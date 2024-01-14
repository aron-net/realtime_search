require 'ipaddr'
require_relative '../models/search_log' # Import the SearchLog class

class AnalyticsController < ApplicationController
  def index
    @search_logs = SearchLog.all.order(last_searched: :desc)
  end
 
end
