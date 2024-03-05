require 'rails_helper'

RSpec.describe "Ingredients", type: :request do
  describe "GET #search" do
    context "when the name parameter is provided" do
      let!(:ingredient) { create(:ingredient, name: "cucumber") }

      it "returns a list of matching ingredients" do
        get "/ingredients/search", params: { name: "cucumber" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).first["name"]).to eq("cucumber")
      end
    end

    context "when the name parameter is missing" do
      it "returns a bad request status" do
        get "/ingredients/search", params: {}

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("Name parameter is missing")
      end
    end
  end
end
