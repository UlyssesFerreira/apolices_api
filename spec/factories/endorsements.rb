FactoryBot.define do
  factory :endorsement do
    data_emissao { Date.today }
    tipo { "aumento_is" }
    inicio_vigencia { Date.today }
    importancia_segurada { 10_000 }
    fim_vigencia { Date.today + 1.year }
    policy
  end
end
