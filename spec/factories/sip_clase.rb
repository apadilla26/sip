# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sip_clase, class: 'Sip::Clase' do
		id 100000 # No intefiere con existentes
    nombre "CLASE1"
    latitud 1.5
    longitud 1.5
    fechacreacion "2014-08-04"
    fechadeshabilitacion "2014-08-04"
		id_municipio 1
		id_tclase 'CAS'
  end
end
