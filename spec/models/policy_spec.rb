require "rails_helper"

RSpec.describe Policy, type: :model do

  describe "validations" do
    it "is invalid without numero" do
      policy = build(:policy, numero: nil)
      expect(policy).not_to be_valid
    end

    it "is invalid with a duplicate numero" do
      create(:policy)
      expect(build(:policy)).not_to be_valid
    end

    it "is invalid without data emissao" do
      policy = build(:policy, data_emissao: nil)
      expect(policy).not_to be_valid
    end

    it "is invalid without inicio vigencia" do
      policy = build(:policy, inicio_vigencia: nil)
      expect(policy).not_to be_valid
    end

    it "is invalid without fim vigencia" do
      policy = build(:policy, fim_vigencia: nil)
      expect(policy).not_to be_valid
    end

    it "is invalid with fim vigencia before inicio vigencia" do
      policy = build(:policy, inicio_vigencia: Date.today, fim_vigencia: Date.today - 1.day)
      expect(policy).not_to be_valid
    end

    context "importancia segurada and lmg validations" do
      it "is invalid without importancia segurada" do
        policy = build(:policy, importancia_segurada: nil)
        expect(policy).not_to be_valid
      end

      it "is invalid without lmg" do
        policy = build(:policy, lmg: nil)
        expect(policy).not_to be_valid
      end

      it "is invalid with importancia segurada and lmg less than 0" do
        policy = build(:policy, importancia_segurada: -100, lmg: -100)
        expect(policy).not_to be_valid
      end
    end

    context "inicio vigencia within allowed range" do
      it "is valid if inicio vigencia is within 30 days before data emissao" do
        policy = build(:policy, data_emissao: Date.today, inicio_vigencia: Date.today - 30.days)
        expect(policy).to be_valid
      end

      it "is invalid if inicio vigencia is more than 30 days before data emissao" do
        policy = build(:policy, data_emissao: Date.today, inicio_vigencia: Date.today - 31.days)
        expect(policy).not_to be_valid
      end

      it "is invalid if inicio vigencia is more than 30 days after data emissao" do
        policy = build(:policy, data_emissao: Date.today, inicio_vigencia: Date.today + 31.days)
        expect(policy).not_to be_valid
      end
    end
  end

  describe "callbacks" do
    it "sets original values before create" do
      policy = create(:policy, importancia_segurada: 7000, fim_vigencia: Date.today + 2.years)
      expect(policy.importancia_segurada_original).to eq(7000)
      expect(policy.fim_vigencia_original).to eq(Date.today + 2.years)
    end
  end
end
