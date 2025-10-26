require "rails_helper"

RSpec.describe "Api::Endorsements", type: :request do
  describe 'POST /api/endorsements' do
    let(:policy) { create(:policy, importancia_segurada: 10_000, inicio_vigencia: Date.today, fim_vigencia: Date.today + 1.year) }

    context "Endorsement types" do
      it "creates an Endorsement of the type aumento_is" do
        endorsement_params = {
          endorsement: {
            importancia_segurada: 15_000
          }
        }
        post api_policy_endorsements_path(policy.id), params: endorsement_params
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response.dig("tipo")).to eq("aumento_is")
        expect(json_response.dig("importancia_segurada")).to eq(15_000.0)
      end

      it "creates an Endorsement of the type reducao_is" do
        endorsement_params = {
          endorsement: {
            importancia_segurada: 8_000
          }
        }
        post api_policy_endorsements_path(policy.id), params: endorsement_params
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response.dig("tipo")).to eq("reducao_is")
        expect(json_response.dig("importancia_segurada")).to eq(8_000.0)
      end

      it "creates an Endorsement of the type alteracao_vigencia" do
        endorsement_params = {
          endorsement: {
            fim_vigencia: Date.today + 2.year
          }
        }
        post api_policy_endorsements_path(policy.id), params: endorsement_params
        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response["tipo"]).to eq("alteracao_vigencia")
        expect(json_response["fim_vigencia"]).to eq((Date.today + 2.year).to_s)
      end

      it "creates an Endorsement of the type aumento_is_alteracao_vigencia" do
        endorsement_params = {
          endorsement: {
            importancia_segurada: 12_000,
            fim_vigencia: Date.today + 2.year
          }
        }
        post api_policy_endorsements_path(policy.id), params: endorsement_params
        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response["tipo"]).to eq("aumento_is_alteracao_vigencia")
        expect(json_response["importancia_segurada"]).to eq(12_000)
        expect(json_response["fim_vigencia"]).to eq((Date.today + 2.year).to_s)
      end

      it "creates an Endorsement of the type reducao_is_alteracao_vigencia" do
        endorsement_params = {
          endorsement: {
            importancia_segurada: 5_000,
            fim_vigencia: Date.today + 3.year
          }
        }
        post api_policy_endorsements_path(policy.id), params: endorsement_params
        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response["tipo"]).to eq("reducao_is_alteracao_vigencia")
        expect(json_response["importancia_segurada"]).to eq(5_000)
        expect(json_response["fim_vigencia"]).to eq((Date.today + 3.year).to_s)
      end

      it "creates an Endorsement of the type cancelamento" do
        endorsement = create(:endorsement, policy: policy)
        post cancel_api_policy_endorsements_path(policy.id)
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response["tipo"]).to eq("cancelamento")
        expect(json_response["cancelled_endorsement_id"]).to eq(endorsement.id)
      end
    end

    it "updates policy status to baixada when there is no endorsement to restore" do
      endorsement = create(:endorsement, policy: policy)
      post cancel_api_policy_endorsements_path(policy.id)
      expect(response).to have_http_status(:created)
      policy.reload

      expect(policy.baixada?).to be_truthy
    end

    it "updates policy lmg when importancia segurada is changed" do
      endorsement_params = {
        endorsement: {
          importancia_segurada: 2_000
        }
      }
      post api_policy_endorsements_path(policy.id), params: endorsement_params
      expect(response).to have_http_status(:created)
      policy.reload
      expect(policy.lmg).to eq(2_000)
    end
  end
end
