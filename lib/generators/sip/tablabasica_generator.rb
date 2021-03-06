# encoding: UTF-8
require 'rails/generators/base'

module Sip
    class TablabasicaGenerator < Rails::Generators::Base
      desc "Genera tabla básica"

      source_root File.expand_path('../templates', __FILE__)

      argument :tablabasica, :type => :string
      argument :tablabasicaplural, :type => :string
      class_option :modelo, :type => :boolean, :default => false, 
        :desc => "Genera modelo"  
      class_option :controlador, :type => :boolean, :default => true, 
        :desc => "Genera controlador"  
      class_option :test, :type => :boolean, :default => true, 
        :desc => "Genera prueba minitest para el modelo"  
      class_option :factory, :type => :boolean, :default => true, 
        :desc => "Genera ejemplo de datos para factory_girl"  
      class_option :asocia, :type => :string, :default => '',
        :desc => 'Crea un belongs_to en un tabla'

      def genera_tablabasica
        if ENV['DISABLE_SPRING'].to_i != 1 then
          #http://makandracards.com/makandra/24525-disabling-spring-when-debugging
          puts "Ejecutar con DISABLE_SPRING=1"
          exit 1
        end
        if tablabasica == tablabasicaplural
          puts "El nombre en singular debe ser diferente al nombre en plural para que opere bien agregar registros a la tabla basica"
          exit 1
        end
        genera_modelo if options.modelo
        genera_controlador if options.controlador
        genera_test if options.test
        genera_factory if options.factory
        genera_asociacion if options.asocia != ''
      end

      private
      def genera_modelo
        template "tablabasica.rb.erb", 
          "app/models/#{nom_arch}.rb"
				generate "migration", "Create#{nom_arch.camelize} " +
					"nombre:string{500} observaciones:string{5000} " +
					"fechacreacion:date fechadeshabilitacion:date " +
					"created_at:timestamp updated_at:timestamp"
        if File.readlines("app/models/ability.rb").grep(/#{nom_arch}/).size == 0
          gsub_file("app/models/ability.rb", /(BASICAS_PROPIAS = \[.*)/, 
                   "\1\n    ['', '#{nom_arch}'],")
        end
        puts "Aregue manualmente null:false en :nombre, :fechacreacion, :created_at y :update_at en migración"
        puts "Aregue manualmente infleccion no regular en config/initializers/inflections.rb al estilo:"
        puts "  inflect.irregular '#{tablabasica}', '#{tablabasicaplural}' "
        puts "Aregue nombre en español en config/locales/es.yml al estilo:"
        puts "  \"#{tablabasica}\":"
        puts "    #{tablabasica.capitalize}: Descripción singular"
        puts "    #{tablabasicaplural.capitalize}: Descripción plural"
      end

      def genera_controlador
        template "tablasbasicas_controller.rb.erb", 
          "app/controllers/admin/#{nom_arch_plural}_controller.rb"
      end

      def genera_test
        template "tablabasica_test.rb.erb", 
          "test/models/#{nom_arch}_test.rb"
        template "tablasbasicas_controller_test.rb.erb", 
          "test/controllers/#{nom_arch_plural}_controller_test.rb"
      end

      def genera_factory
        template "factory_tablabasica.rb.erb", 
          "test/factories/#{nom_arch}.rb"
      end

      def genera_asocion
        if File.readlines("app/models/#{options.asocia}.rb").grep(/#{nom_arch}/).size == 0
          puts "Aregue belongs_to"
        end
      end

      def nom_arch
        tablabasica.underscore
      end

      def nom_arch_plural
        tablabasicaplural.underscore
      end

      def nom_clase
        tablabasica.capitalize
      end

      def nom_clase_plural
        tablabasicaplural.capitalize
      end
    end
end

