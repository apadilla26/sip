# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sip_pais, class: 'Sip::Pais' do
    id 1000  # No interfiere con los ya definidos
    nombre "PASI1"
    nombreiso "PAIS1"
    fechacreacion "2014-08-04"
  end
end
