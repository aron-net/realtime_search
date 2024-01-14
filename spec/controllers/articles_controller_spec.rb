require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe ArticlesController, type: :controller do
    FactoryBot.define do
        factory :article do
          title { 'Sample Article' }
          paragraph { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.' }
          # Add other attributes as needed
        end
      end
    describe "GET #index" do
        it "returns a successful response" do
            get :index
            expect(response).to be_successful
            expect(assigns(:articles)).not_to be_nil
        end

        it "returns a successful response with search parameter" do
            get :index, params: { search: 'ruby' }
            expect(response).to be_successful
            expect(assigns(:articles)).not_to be_nil
            
        end
    end

    describe "GET #index JSON format" do
        it "returns JSON response with all articles" do
            articles = create_list(:article, 3)
            get :index, format: :json
            expect(response).to be_successful
            expect(JSON.parse(response.body)).to eq(JSON.parse(articles.to_json))
        end

        it "returns JSON response with filtered articles" do
            article = create(:article, title: 'Ruby on Rails')
            get :index, params: { search: 'rails' }, format: :json
            expect(response).to be_successful
            expect(JSON.parse(response.body)).to eq(JSON.parse([article].to_json))
        end
    end

    describe "POST #record_search" do
        it "records a valid search" do
            post :record_search, params: { search: 'ruby' }
            expect(response).to be_successful
            expect(JSON.parse(response.body)['success']).to be_truthy
            expect(JSON.parse(response.body)['message']).to eq('Search recorded successfully')
        end

        it "does not record an invalid search" do
            post :record_search, params: { search: '' }
            expect(response).to be_successful
            expect(JSON.parse(response.body)['success']).to be_falsy
            expect(JSON.parse(response.body)['message']).to eq('Invalid or repetitive search query')
        end
    end
    describe "POST #record_search" do
        let(:article_title) { "Test Article" }
    
        context "when the search is valid" do
          it "records a valid search and returns a success response" do
            expect {
              post :record_search, params: { search: article_title }
            }.to change(SearchLog, :count).by(1)
    
            expect(response).to be_successful
            json_response = JSON.parse(response.body)
            expect(json_response['success']).to be_truthy
          end
        end
    
        context "when the search is invalid" do
          it "does not record an invalid search and returns a failure response" do
            # Assuming you have a FactoryBot factory for search_log
            existing_search_log = FactoryBot.create(:search_log, query: article_title)
    
            expect {
              post :record_search, params: { search: article_title }
            }.not_to change(SearchLog, :count)
    
            expect(response).to be_successful
            json_response = JSON.parse(response.body)
            expect(json_response['success']).to be_falsy
          end
        end
      end
    
      describe "private #valid_search?" do
            
        it "returns false for an invalid search" do
          # Assuming you have a FactoryBot factory for search_log
          FactoryBot.create(:search_log, query: "Invalid Search")
          expect(controller.send(:valid_search?, "Invalid Search")).to be_falsy
        end
    
        it "returns false for a repetitive search" do
          search_log = FactoryBot.create(:search_log, query: "Repetitive Search")
          controller.send(:log_search, "Repetitive Search", request)
          expect(controller.send(:valid_search?, "Repetitive Search")).to be_falsy
        end
      end
end
