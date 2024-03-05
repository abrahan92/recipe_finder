require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  describe "GET #search" do
    let!(:recipe) { create(:recipe, :brownie) }

    context "when ingredients parameter is provided" do
      before do
        get "/recipes/search", params: { ingredients: "flour,sugar", page: "1", exact_match: "true" }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the correct number of recipes" do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["recipes"].size).to eq(1)
      end

      it "includes pagination metadata" do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include("meta")
        expect(parsed_response["meta"]).to include("total_pages", "total_count", "page")
      end
    end

    context "when ingredients parameter is missing" do
      before do
        get "/recipes/search", params: {}
      end

      it "returns a bad request status" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error message" do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include("error" => "Ingredients parameter is missing")
      end
    end
  end
end
