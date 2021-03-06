# encoding: UTF-8

require 'rails_helper'


RSpec.describe Sip::UsuariosController, :type => :controller do
  routes { Sip::Engine.routes }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:usuario]
    u = build(:usuario)
    controller.stub(:current_usuario).and_return(u)
  end

  it "should have a current_user" do
    expect(subject.current_usuario).not_to be_nil
  end
  # Atributos mínimos para crear un usuario válido.
  let(:valid_attributes) {
    { nombre: "n",
      nusuario: 'nusuario',
      email: 'x@x.org',
      fechacreacion: '2014-1-1',
      encrypted_password: 'x',
      created_at: "2014-11-11" }
  }

  let(:invalid_attributes) {
    { nombre: '',
			nusuario: '',
      created_at: '2014-11-11' }
  }

  # Atributos mínimos de valores de sesión para pasar filtros (como 
  # autenticación) definidos en UsuariosController.
  # De http://luisalima.github.io/blog/2013/01/09/how-i-test-part-iv/
  let(:valid_session) { 
    {"warden.user.user.key" => session["warden.user.user.key"]}
  }

  describe "GET index" do
    it "asigna todos los usuarios como @usuarios" do
      if Usuario.where(nusuario: 'nusuario').count > 0 
        usuario = Usuario.where(nusuario: 'nusuario').take
      else
        usuario = Usuario.create! valid_attributes
      end
      get :index, {}, valid_session
      #expect(assigns(:usuarios)).to eq([usuario])
      usuario.destroy!
    end
  end

  describe "GET show" do
    it "asigna el usuario requerido como @usuario" do
      usuario = Usuario.create! valid_attributes
      get :show, {:id => usuario.to_param}, valid_session
      expect(assigns(:usuario)).to eq(usuario)
      usuario.destroy!
    end
  end

  describe "GET new" do
    it "asigna un nuevo usuario como @usuario" do
      get :new, {}, valid_session
      expect(assigns(:usuario)).to be_a_new(Usuario)
    end
  end

  describe "GET edit" do
    it "asigna el usuario requerido como @usuario" do
      usuario = Usuario.create! valid_attributes
      get :edit, {:id => usuario.to_param}, valid_session
      expect(assigns(:usuario)).to eq(usuario)
      usuario.destroy!
    end
  end

  describe "POST create" do
    describe "con parámetros validos" do
      it "crea una Usuario" do
        expect {
          post :create, {:usuario => valid_attributes}, valid_session
        }.to change(Usuario, :count).by(1)
      end

      it "asigna el usuario recien creado como @usuario" do
        post :create, {:usuario => valid_attributes}, valid_session
        expect(assigns(:usuario)).to be_a(Usuario)
        #expect(assigns(:usuario)).to be_persisted
        usuario = Usuario.where(nusuario: 'nusuario').take
        usuario.destroy!
      end

      it "redirige al usuario creado" do
        post :create, {:usuario => valid_attributes}, valid_session
        #expect(response.status).to eq(200)
        expect(response).to redirect_to(Usuario.last)
        usuario = Usuario.where(nusuario: 'nusuario').take
        usuario.destroy!
      end
    end

    describe "con parámetros invalidos" do
      it "asigna un usuario recien creado pero no salvado como @usuario" do
        skip
        post :create, {:usuario => invalid_attributes}, valid_session
        expect(assigns(:usuario)).to be_a_new(Usuario)
      end

      it "vuelve a presentar la plantilla 'nueva'" do
        skip
        post :create, {:usuario => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "con parámetros válidos" do
      let(:new_attributes) {
        { minutos: "90", nombre: "nombreact2",
          fecha: "2014-11-18", created_at: "2014-11-18" }
      }

      it "actualiza el usuario requerido" do
        usuario = Usuario.create! valid_attributes
        put :update, {:id => usuario.to_param, :usuario => new_attributes}, valid_session
        usuario.reload
        usuario.destroy!
        #expect(usuario.oficina_id).to eq(1)
      end

      it "asigna el usuario requerido como @usuario" do
        usuario = Usuario.create! valid_attributes
        put :update, {:id => usuario.to_param, :usuario => valid_attributes}, valid_session
        expect(assigns(:usuario)).to eq(usuario)
        usuario.destroy!
      end

      it "redirige al usuario" do
        usuario = Usuario.create! valid_attributes
        put :update, {:id => usuario.to_param, :usuario => valid_attributes}, valid_session
        expect(response).to redirect_to(usuario)
        usuario.destroy!
      end
    end

    describe "con parametros inválidos" do
      it "asinga el usuario como @usuario" do
        usuario = Usuario.create! valid_attributes
        put :update, {:id => usuario.to_param, :usuario => invalid_attributes}, valid_session
        expect(assigns(:usuario)).to eq(usuario)
        usuario.destroy!
      end

      it "vuelve a presentar la plantilla 'editar'" do
        usuario = Usuario.create! valid_attributes
        put :update, {:id => usuario.to_param, :usuario => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
        usuario.destroy!
      end
    end
  end

  describe "DELETE destroy" do
    it "elimina el usuario requerido" do
      if Usuario.where(nusuario: 'nusuario').count > 0 
        usuario = Usuario.where(nusuario: 'nusuario').take
      else
        usuario = Usuario.create! valid_attributes
      end
      expect {
        delete :destroy, {:id => usuario.to_param}, valid_session
      }.to change(Usuario, :count).by(-1)
    end

    it "redirige a la lista de usuarios" do
      usuario = Usuario.create! valid_attributes
      delete :destroy, {:id => usuario.to_param}, valid_session
      expect(response).to redirect_to(usuarios_path)
    end
  end

end
