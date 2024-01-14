require 'rails_helper'
require_relative '../../app/controllers/analytics_controller'
require 'factory_bot_rails'

RSpec.describe AnalyticsController, type: :controller do
  before(:each) do
    @valid_query = "test query"
    @invalid_query = ""
    @existing_query = FactoryBot.create(:search_log).query
    @ipv4_address = "192.168.1.1"
    @ipv6_address = "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
    @ipv4_mapped_ipv6_address = "::ffff:192.168.1.1"
    @windows_user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    @mac_user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
    @linux_user_agent = "Mozilla/5.0 (X11; Linux x86_64)"
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
      expect(assigns(:search_logs)).not_to be_nil
    end
  end

  
end
