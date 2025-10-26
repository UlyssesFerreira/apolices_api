FactoryBot.define do
  factory :policy do
    numero { "1" }
    data_emissao { Date.today }
    inicio_vigencia { Date.today }
    fim_vigencia { Date.today + 1.year }
    importancia_segurada { 5_000 }
    lmg { 5_000 }
  end
end
