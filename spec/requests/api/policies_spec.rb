require "rails_helper"

RSpec.describe "Api::Policies", type: :request do
  describe 'POST /api/policies' do
    let(:new_policy) do
      {
        policy: {
          numero: "1",
          data_emissao: Date.today,
          inicio_vigencia: Date.today,
          fim_vigencia: Date.today + 1.year,
          importancia_segurada: 5000,
          lmg: 7000
        }
      }
    end

    it "creates a new Policy with valid attributes" do
      post api_policies_path, params: new_policy
      expect(response).to have_http_status(:created)
      expect(Policy.count).to eq(1)
    end
  end
end
